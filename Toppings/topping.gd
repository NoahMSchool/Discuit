extends Area3D

#@export var topping_num = 0

@onready var topping_meshes = [$MeshContainer/Blueberry, $MeshContainer/GumDrop, $MeshContainer/Chocolate, $MeshContainer/Almond, $MeshContainer/Acorn]
@onready var rest_pos = global_position

@onready var topping_images: Array[Image] = [
	(preload("res://Toppings/blueberryIcon.png") as Texture2D).get_image(),
	(preload("res://Toppings/gumdrop_icon.png") as Texture2D).get_image(),
	(preload("res://Toppings/ChocolateIcon.png") as Texture2D).get_image(),
	(preload("res://Toppings/AlmondIcon.png") as Texture2D).get_image(),
	(preload("res://Toppings/AcornIcon.png") as Texture2D).get_image(),
]


@onready var topping_num = randi_range(0,topping_meshes.size()-1)

func _ready() -> void:
	
	#topping_num = clamp(topping_num, 0, topping_meshes.size())
	topping_meshes[topping_num].visible = true

var target_pos : Vector3

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		body.add_topping(topping_images[topping_num])
		monitoring = false
		target_pos = body.global_position
		#visible = false
		queue_free()

var period = 0
func _physics_process(delta: float) -> void:
	period += delta
	global_position.y = rest_pos.y + sin(period)/4
	rotate_y(delta*TAU/4)
	
	#if target_pos:
		#global_position = lerpf(gl)
