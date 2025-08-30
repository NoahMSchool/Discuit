extends Control

func _ready() -> void:
	$BestTotalScore/TotalFlingsLabel.text = str(GameManager.run_data[0])

	var format_string = """
	Hole 1 : %s flings
	Hole 2 : %s flings
	Hole 3 : %s flings
	"""	
	var actual_string = format_string %[GameManager.run_data[1], GameManager.run_data[2], GameManager.run_data[3]]
	
	$HoleScores/HoleFlingsLabel.text = actual_string

func _on_home_screen_pressed() -> void:
	SoundManager.get_node("ClickSound").play()
	print("returning to start")
	GameManager.current_screen = GameManager.screen.START
