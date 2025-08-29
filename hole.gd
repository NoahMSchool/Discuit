extends Resource

class_name Hole

@export var name : String
@export var hole_num : int
@export var toppings_req : int
@export var player_best = INF

func _init(_name : String, _hole_num : int, _toppings_req : int) -> void:
	name = _name
	toppings_req = _toppings_req
	hole_num = _hole_num
	
