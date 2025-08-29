extends CanvasLayer

@onready var counter_label: Label = $FlingCount/CounterPanel/CounterLabel
@onready var hole_label: Label = $HoleNum/CounterPanel/CounterLabel

@onready var toppings_slots = [$Panel/ToppSlot1, $Panel/ToppSlot2, $Panel/ToppSlot3, $Panel/ToppSlot4, $Panel/ToppSlot5]

func update_flingcount(flings :int = 0):
	counter_label.text = str(flings)

func update_holenum(hole :int):
	hole_label.text = str(hole+1)

func deactivate_topping_slots():
	for t in toppings_slots:
		t.get_child(0).set_texture(null)
		t.visible = false
		#print(t)

func activate_topping_slots(num : int):
	num = clamp(num, 0, toppings_slots.size())
	deactivate_topping_slots()
	for i in range(num):
		toppings_slots[i].visible = true
		$Panel/ToppSlot1.visible = true

func set_topping_slot(num : int, img : Image):
	var tex_rec : TextureRect = toppings_slots[num-1].get_child(0)
	print(num)
	print(toppings_slots[num-1])
	var image_tex: ImageTexture = ImageTexture.create_from_image(img)
	tex_rec.texture = null
	tex_rec.set_texture(image_tex)
	tex_rec.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex_rec.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
func set_objective_text(text : String):
	$ObjectivePanel/Label.text = text
