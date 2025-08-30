extends Control

@onready var button_hole_1: Button = $"Course Selector/ButtonHole1"


func go_to_game():
	GameManager.current_screen = GameManager.screen.PLAYING
	
func _on_button_hole_1_pressed() -> void:
	SoundManager.get_node("ClickSound").play()
	go_to_game()
