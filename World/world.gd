extends Node3D

@onready var hole_node: Node3D = $HoleNode
@onready var discuit_node : RigidBody3D = $Discuit
@onready var hud: CanvasLayer = $HUD

#probably dont need holenum
var holes : Array[Hole] = [Hole.new("Hilly Hole", 0), Hole.new("Cliffy Canyon", 2),]
var hole_scenes : Array[PackedScene] = [preload("res://holes/hole_1.tscn"), preload("res://holes/hole_3.tscn"),]

@onready var current_hole_num : int = 0

func start_hole(hole_num):
	while not hole_scenes[hole_num].can_instantiate():
		hole_num += 1
		
	if hole_node.get_child_count() > 0:
		hole_node.get_children()[0].queue_free()
	var new_hole = hole_scenes[hole_num].instantiate()
	hole_node.add_child(new_hole)
	var hole_start = new_hole.get_node("HoleStart")
	hole_start.spawn(discuit_node)
	hud.update_holenum(hole_num)
	
	
	
func level_completed(flings_used):
	start_hole(current_hole_num+1)

func discuit_dead():
	start_hole(current_hole_num)


func _ready() -> void:
	start_hole(0)

func use_fling():
	hud.update_flingcount()

func _on_discuit_use_fling(current_flings) -> void:
	hud.update_flingcount(current_flings)
	print("hi")
	print(discuit_node)
	print(discuit_node.flings_used)
