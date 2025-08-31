extends AnimatableBody3D

signal hole_target_reached
var period : float = 0

func _physics_process(delta: float) -> void:
	period += delta
	#period = modf(period, TAU)
	global_rotate(Vector3(0,1,0), delta*TAU*0.1)
	#position.z = sin(period*TAU*0.5)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		hole_target_reached.emit()
		SoundManager.get_node("CompleteSound").play()
