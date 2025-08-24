extends RigidBody3D

@onready var cam_target: Node3D = $CamPivot/CamTarget
@onready var cam_pivot: Node3D = $CamPivot

@onready var cam: Camera3D = $Camera3D

func _ready() -> void:
	#apply_central_impulse(Vector3(5,1,-15))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cam.global_position.x = lerpf(cam.global_position.x, cam_target.global_position.x, delta*2)
	cam.global_position.y = lerpf(cam.global_position.y, cam_target.global_position.y, delta*2)
	cam.global_position.z = lerpf(cam.global_position.z, cam_target.global_position.z, delta*2)
	
	if Input.is_action_pressed("left"):
		cam_pivot.rotate_y(-delta)
		
	if Input.is_action_pressed("right"):
		cam_pivot.rotate_y(delta)
	#cam.global_rotation.y = cam_pivot.global_rotation.y
	cam.look_at(global_position, Vector3(0,1,0))
	
	if Input.is_action_just_pressed("ui_accept"):
		fling(5)
		

func fling(power : float):
	var innacuracy = (randf()-0.5) * PI/8
	var direction = Vector3(cam.global_rotation.x, 1, cam.global_rotation.z).normalized()
	direction.rotated(Vector3(0,1,0), innacuracy)
	apply_central_impulse(direction*power)
	#apply_impulse()
