extends Resource

class_name Hole

@export var name : String
@export var hole_num : int
@export var player_best = INF

func _init(_name : String, _hole_num : int) -> void:
	name = _name
	hole_num = _hole_num
	
