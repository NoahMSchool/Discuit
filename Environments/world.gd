extends Node3D

@onready var hole_node: Node3D = $HoleNode
@onready var discuit_node : RigidBody3D = $Discuit
@onready var hud: CanvasLayer = $HUD

var holes : Array[PackedScene] = [preload("res://hole_1.tscn")]

@onready var hole_num : int

func start_hole(hole):
	hud.update_holenum(hole_num)
	var new_hole = holes[hole_num].instantiate()
	#hole_node.add_child(new_hole)
	hole_node.add_child(new_hole)
	var hole_start = new_hole.get_node("HoleStart")
	
	hole_start.spawn(discuit_node)
	
	
func level_completed(flings_used):
	start_hole(hole_num)

func discuit_dead():
	start_hole(hole_num)


func _ready() -> void:
	start_hole(1)

func use_fling():
	hud.update_flingcount()

func _on_discuit_use_fling(current_flings) -> void:
	hud.update_flingcount(current_flings)
	print("hi")
	print(discuit_node)
	print(discuit_node.flings_used)
