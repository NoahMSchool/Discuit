extends Control

@onready var button_hole_1: Button = $"Course Selector/ButtonHole1"



func _on_button_hole_1_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")
