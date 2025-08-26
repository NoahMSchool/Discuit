extends RigidBody3D

@onready var cam_target: Node3D = $CamTarget
@onready var cam: Camera3D = $CamTarget/SpringArm3D/Camera3D
@onready var targeting_arrow = $Arrow

var cam_sens = 0.00025

@export var torque_power = 0.75
@export var max_fling_power = 2.5
var fling_power = 0

var cam_follow_speed = 3

var flings_used = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cam_target.global_position.x = lerpf(cam_target.global_position.x, global_position.x, delta*cam_follow_speed)
	cam_target.global_position.y = lerpf(cam_target.global_position.y, global_position.y, delta*cam_follow_speed)
	cam_target.global_position.z = lerpf(cam_target.global_position.z, global_position.z, delta*cam_follow_speed)

	if Input.is_action_pressed("launch"):
		fling_power = move_toward(fling_power, max_fling_power, delta)
		targeting_arrow.visible = true
		
		targeting_arrow.global_position = global_position
		targeting_arrow.global_basis.z = cam_target.global_basis.z
		targeting_arrow.global_rotation.x = 0
		targeting_arrow.global_rotation.z = PI/2
		
	elif Input.is_action_just_released("launch"):
		targeting_arrow.visible = false
		fling(fling_power)
	else:
		fling_power = 0
			
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("freemouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var torque_dir = Input.get_action_raw_strength("right")- Input.get_action_raw_strength("left")
	apply_torque(cam_target.basis.y*torque_dir*torque_power*delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_target.rotation.y -= event.relative.x*cam_sens
		cam_target.rotation.x -= event.relative.y*cam_sens
		cam_target.rotation.x = clamp(cam_target.rotation.x, -PI/4, PI/8)


func fling(power : float):
	flings_used += 1
	var innacuracy = (randf()-0.5) * PI/8
	var launch_dir = -cam_target.global_basis.z
	launch_dir.y = 0
	launch_dir = launch_dir.normalized()
	launch_dir.y = 1
	launch_dir.rotated(Vector3(0,1,0), innacuracy)
	
	apply_central_impulse(launch_dir*power)


func reset(position : Vector3):
	flings_used = 0
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	print("reset")
	global_position = position
	
	
func die():
	print("you died")
