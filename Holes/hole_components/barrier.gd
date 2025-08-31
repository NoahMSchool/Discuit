extends StaticBody3D

@export var length = 10
@export var height = 5
@export var thickness = 1
@export var facing_vector : Vector3 = Vector3(1,0,0)
@export var wind_thickness = 3


var discuit_in: = false
var discuit_node : RigidBody3D

func _ready() -> void:
	var box = BoxShape3D.new()
	box.size = Vector3(length, height, thickness)
	$FrontBarrier.shape = box
	
	var area_box = BoxShape3D.new()
	area_box.size = Vector3(length, height, wind_thickness)
	$Area3D/CollisionShape3D.shape = box
	
	$Area3D.global_position.z = global_position.z - thickness-wind_thickness/2
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		discuit_in = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		discuit_in = false

func _physics_process(delta: float) -> void:
	if discuit_node and discuit_in:
		discuit_node.apply_central_force(facing_vector*delta*50)
		
