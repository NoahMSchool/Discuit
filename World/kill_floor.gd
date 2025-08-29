extends Area3D

@onready var world = $".."

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		world.discuit_dead()
		$AudioStreamPlayer3D.play()
