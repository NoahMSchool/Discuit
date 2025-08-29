extends Area3D

#@export var topping_num = 0

@onready var topping_meshes = [$MeshContainer/Blueberry, $MeshContainer/GumDrop, $MeshContainer/Chocolate, $MeshContainer/Almond, $MeshContainer/Acorn]
@onready var topping_images = [Image.load_from_file("res://Toppings/blueberryIcon.png"), 
								Image.load_from_file("res://Toppings/gumdrop_icon.png"), 
								Image.load_from_file("res://Toppings/ChocolateIcon.png"), 
								Image.load_from_file("res://Toppings/AlmondIcon.png"), 
								Image.load_from_file("res://Toppings/AcornIcon.png")
								]

@onready var topping_num = randi_range(0,topping_meshes.size()-1)

func _ready() -> void:
	
	#topping_num = clamp(topping_num, 0, topping_meshes.size())
	topping_meshes[topping_num].visible = true
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("discuit"):
		body.add_topping(topping_images[topping_num])
		monitoring = false
		visible = false
		queue_free()
