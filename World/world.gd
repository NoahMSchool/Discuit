extends Node3D

@onready var hole_node: Node3D = $HoleNode
@onready var discuit_node : RigidBody3D = $Discuit
@onready var hud: CanvasLayer = $HUD

#probably dont need holenum
#Move to game manager

var holes : Array[Hole] = [
	Hole.new("Hilly Hole", 0, 3), 
	Hole.new("River Run", 1, 4), 
	Hole.new("Cliffy Canyon", 2, 3),
]

var hole_scenes : Array[PackedScene] = [
	preload("res://Holes/hole_1.tscn"), 
	preload("res://Holes/hole_2.tscn"), 
	preload("res://Holes/hole_3.tscn"),
]

@onready var current_hole_num : int = 2


func start_hole(hole_num):
	while not hole_scenes[hole_num].can_instantiate():
		hole_num += 1
		
	if hole_node.get_child_count() > 0:
		hole_node.get_children()[0].queue_free()
	var new_hole = hole_scenes[hole_num].instantiate()
	hole_node.add_child(new_hole)
	
	var hole_target = new_hole.get_node("TargetBasket")
	hole_target.hole_target_reached.connect(on_hole_target_reached)
	
	var hole_start = new_hole.get_node("HoleStart")
	hole_start.spawn(discuit_node)
	hud.update_holenum(hole_num)
	hud.update_flingcount()
	hud.activate_topping_slots(holes[hole_num].toppings_req)
	hud.set_objective_text("Collect " + str(holes[hole_num].toppings_req) + " toppings before you can finish")
	

func on_hole_target_reached():
	if not discuit_node.topping_count < holes[current_hole_num].toppings_req:
		current_hole_num += 1
		start_hole(current_hole_num)
	else:
		print("discuit does not have enough toppings")

func discuit_dead():
	start_hole(current_hole_num)


func _ready() -> void:
	start_hole(current_hole_num)

func use_fling():
	hud.update_flingcount()

func _on_discuit_use_fling(current_flings) -> void:
	hud.update_flingcount(current_flings)

func _on_discuit_topping_collected(image : Image) -> void:
	hud.set_topping_slot(discuit_node.topping_count, image)
	var objective_string = ""
	objective_string = objective_string + str(discuit_node.topping_count) + "/" + str(holes[current_hole_num].toppings_req) + " toppings,  "
	if discuit_node.topping_count < holes[current_hole_num].toppings_req:
		objective_string += "Need more before you can finish"
	else:
		objective_string += "Go To Finish"
		
	hud.set_objective_text(objective_string)
