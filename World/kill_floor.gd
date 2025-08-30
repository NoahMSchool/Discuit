extends Area3D

@export var width = 40
@export var length = 60
@export var depth = 5
func _ready() -> void:
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(width, depth, length)
	$CollisionShape3D.shape = box_shape
	#global_position.y = global_position.y-depth/2
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		$AudioStreamPlayer3D.play()
		body.discuit_die()
