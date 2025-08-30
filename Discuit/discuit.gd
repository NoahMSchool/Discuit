extends RigidBody3D

signal use_fling
signal topping_collected
#signal discuit_dead

@onready var cam_target: Node3D = $CamTarget
@onready var cam: Camera3D = $CamTarget/SpringArm3D/Camera3D
@onready var targeting_arrow = $Arrow

var last_fling_pos : Vector3

var cam_sens = 0.00025

@export var torque_power = 1.5
@export var max_fling_power = 3
@export var max_fling_angle = PI/4 #3*PI/8

var topping_count : int = 0

var fling_power = 0
var fling_angle = 0

var cam_follow_speed = 3
var flings_used = 0

var deaths = 0

func get_launch_vector(angle):
	var innacuracy = (randf()-0.5) * PI
	
	var launch_dir = -cam_target.global_basis.z
	launch_dir.y = 0
	launch_dir = launch_dir.normalized()	
	launch_dir *= cos(fling_angle)
	launch_dir.y =sin(fling_angle)
	
	launch_dir.rotated(Vector3(0,1,0), innacuracy)
	return launch_dir.normalized()

func _physics_process(delta: float) -> void:
	cam_target.global_position.x = lerpf(cam_target.global_position.x, global_position.x, delta*cam_follow_speed)
	cam_target.global_position.y = lerpf(cam_target.global_position.y, global_position.y+0.5, delta*cam_follow_speed)
	cam_target.global_position.z = lerpf(cam_target.global_position.z, global_position.z, delta*cam_follow_speed)
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if linear_velocity.abs().y<0.5 and not Input.is_action_pressed("CancelLaunch"):
		var launch_dir = get_launch_vector(fling_angle)
		
		
		if Input.is_action_pressed("launch") :
			fling_power = move_toward(fling_power, max_fling_power, delta*max_fling_power)
			fling_angle = move_toward(fling_angle, max_fling_angle, delta*max_fling_angle)
			targeting_arrow.global_position = global_position
			targeting_arrow.visible = true
			targeting_arrow.look_at(global_position+launch_dir, Vector3.UP)
			
		elif Input.is_action_just_released("launch"):
			#fling(fling_power, fling_angle)
			fling(launch_dir*fling_power)
		else:
			fling_power = 0
			fling_angle = 0
	else:
		targeting_arrow.visible = false
		
	var torque_dir = Input.get_action_raw_strength("left")-Input.get_action_raw_strength("right")
	if angular_velocity.abs().y<PI*3/2:
		apply_torque(Vector3.UP*torque_dir*torque_power*delta)
		apply_central_force(global_basis.y*delta*5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_target.rotation.y -= event.relative.x*cam_sens
		cam_target.rotation.x -= event.relative.y*cam_sens
		cam_target.rotation.x = clamp(cam_target.rotation.x, -PI/4, PI/8)

func fling(vec : Vector3):
	use_fling.emit(flings_used)
	last_fling_pos = global_position
	flings_used += 1
	$FlingAudio.play()
	apply_central_impulse(vec)

func add_topping(topping_image : Image):
	topping_count += 1
	topping_collected.emit(topping_image)

func start_hole(position : Vector3):
	flings_used = 0
	topping_count = 0
	reset_pos(position)
	
func reset_pos(position = last_fling_pos):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_position = position
	
	
func discuit_die():
	reset_pos()
	deaths += 1
