extends Control

@onready var button_hole_1: Button = $"Course Selector/ButtonHole1"


func go_to_game():
	GameManager.current_screen = GameManager.screen.PLAYING
	
func _on_button_hole_1_pressed() -> void:
	SoundManager.get_node("ClickSound").play()
	go_to_game()


func _on_v_slider_value_changed(value: float) -> void:
	GameManager.mouse_sens = value
	print(GameManager.mouse_sens)

func _ready() -> void:
	$Controls/Volume/VSlider.value = GameManager.mouse_sens
