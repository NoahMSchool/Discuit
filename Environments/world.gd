extends Node3D

@onready var hole_node: Node3D = $HoleNode
@onready var discuit_node : RigidBody3D = $Discuit

var holes : Array[PackedScene] = [preload("res://hole_1.tscn")]

@onready var hole_num : int

func start_hole(hole):
	var new_hole = holes[hole_num].instantiate()
	#hole_node.add_child(new_hole)
	hole_node.add_child(new_hole)
	var hole_start = new_hole.get_node("HoleStart")
	
	hole_start.spawn(discuit_node)
	
	
func level_completed(flings_used):
	start_hole(hole_num)

func discuit_dead():
	start_hole(hole_num)
