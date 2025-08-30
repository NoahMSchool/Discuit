extends Node

@onready var current_hole_num : int = 0

enum screen { 
	START,
	PLAYING,
	END
}

var run_data := [0]

var current_screen : screen = screen.START:
	set(value):
		current_screen = value
		print(current_screen)
		match value:
			screen.START : 
				print("setting to start")
				current_hole_num = 0
				run_data = [0]
				get_tree().change_scene_to_file("res://UserInterface/title_screen.tscn")
				Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_VISIBLE)
			screen.PLAYING :
				print("setting to playing")
				get_tree().change_scene_to_file("res://World/world.tscn")
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			screen.END : 
				print("setting to finish")
				get_tree().change_scene_to_file("res://UserInterface/win_screen_summary.tscn")
				Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_VISIBLE)

var holes : Array[Hole] = [
	Hole.new("Hilly Hole", 0, 3), 
	Hole.new("River Run", 1, 4), 
	Hole.new("Cliffy Canyon", 2, 3),
]


func start_hole():
	print("entering start hole")
	if current_screen == screen.PLAYING:
		var world = get_tree().get_root().get_node("World")
		print(world)
		if world.has_method("start_hole"):
			current_hole_num = world.start_hole(current_hole_num)
	
func hole_completed(flings_used : int):
	run_data[0] += flings_used
	run_data.append(flings_used)
	if flings_used < holes[current_hole_num].player_best:
		holes[current_hole_num].player_best = flings_used
	current_hole_num += 1
	print("hole completed, new current hole is " + str(current_hole_num))
	if current_hole_num+1 > holes.size():
		current_screen = screen.END
		print(flings_used)
	else:
		start_hole()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("freemouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("MagicCheat") and current_screen == screen.PLAYING:
		hole_completed(100 + current_hole_num)
