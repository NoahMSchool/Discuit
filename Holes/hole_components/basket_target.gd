extends StaticBody3D

signal hole_complete

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("levelCompleted")
	hole_complete.emit()
