extends RigidBody3D

signal use_fling
signal topping_collected

@onready var cam_target: Node3D = $CamTarget
@onready var cam: Camera3D = $CamTarget/SpringArm3D/Camera3D
@onready var targeting_arrow = $Arrow

var cam_sens = 0.00025

@export var torque_power = 1.5
@export var max_fling_power = 3
@export var max_fling_angle = PI/4 #3*PI/8

var topping_count : int = 0

var fling_power = 0
var fling_angle = 0

var cam_follow_speed = 3

var flings_used = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cam_target.global_position.x = lerpf(cam_target.global_position.x, global_position.x, delta*cam_follow_speed)
	cam_target.global_position.y = lerpf(cam_target.global_position.y, global_position.y, delta*cam_follow_speed)
	cam_target.global_position.z = lerpf(cam_target.global_position.z, global_position.z, delta*cam_follow_speed)
	
	if Input.is_action_just_pressed("quit"):
			get_tree().quit()
	if Input.is_action_just_pressed("freemouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if linear_velocity.abs().y<0.5:
		targeting_arrow.visible = true
		targeting_arrow.global_position = global_position	
		targeting_arrow.global_basis.z = -cam_target.global_basis.z
		targeting_arrow.global_basis.z.y = 0
		targeting_arrow.global_rotation.z = 0
			
		if Input.is_action_pressed("launch"):
			fling_power = move_toward(fling_power, max_fling_power, delta*max_fling_power)
			fling_angle = move_toward(fling_angle, max_fling_angle, delta*max_fling_angle)

			var right_axis = Vector3.UP.cross(targeting_arrow.global_basis.z)
			#targeting_arrow.global_basis.z - targeting_arrow.global_basis.z.rotated(right_axis, fling_angle)
			#
			#var xz_forward = -cam_target.global_basis.z.normalized()
			#xz_forward.y = 0
			#
			#var right_axis = Vector3.UP.cross(xz_forward).normalized()
			targeting_arrow.global_basis.z = targeting_arrow.global_basis.z.rotated(right_axis, fling_angle).normalized()
			#

			
		elif Input.is_action_just_released("launch"):
			fling(fling_power, fling_angle)
		else:
			fling_power = 0
			fling_angle = 0
	else:
		targeting_arrow.visible = false
	
	var torque_dir = Input.get_action_raw_strength("left")-Input.get_action_raw_strength("right")
	if angular_velocity.abs().y<PI*3/2:
		apply_torque(Vector3.UP*torque_dir*torque_power*delta)
		apply_central_force(global_basis.y*delta*5)


#if global_basis.y.dot(Vector3.UP)<0:
	#global_basis.y = -global_basis.y
#apply_central_force(global_basis.y.normalized()*0.5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_target.rotation.y -= event.relative.x*cam_sens
		cam_target.rotation.x -= event.relative.y*cam_sens
		cam_target.rotation.x = clamp(cam_target.rotation.x, -PI/4, PI/8)


func fling(power : float, angle : float):
	use_fling.emit(flings_used)
	flings_used += 1
	$FlingAudio.play()
	
	
	#var innacuracy = (randf()-0.5) * PI/8
	#launch_dir.rotated(Vector3(0,1,0), innacuracy)
	
	#var launch_forward = power*cos(angle)
	#var launch_up = power*sin(angle)
	#launch_dir.y = 0
	#launch_dir.y = 1
	#launch_dir.rotated(Vector3(1,0,0), angle)
	
	#var launch_dir = -cam_target.global_basis.z
	#launch_dir.y = 0
	#launch_dir = launch_dir.normalized()
	#
	#var right_axis = Vector3.UP.cross(launch_dir)
	#launch_dir = launch_dir.rotated(right_axis, -angle)
	#
	var launch_dir = -cam_target.global_basis.z
	launch_dir.y = 0
	launch_dir = launch_dir.normalized()	
	launch_dir *= cos(angle)
	launch_dir.y =sin(angle)
	launch_dir = launch_dir.normalized()
	apply_central_impulse(launch_dir*power)

func add_topping(topping_image : Image):
	topping_count += 1
	topping_collected.emit(topping_image)
	
func reset(position : Vector3):
	flings_used = 0
	topping_count = 0
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	print("reset")
	global_position = position
	
	
func die():
	print("you died")
