extends CanvasLayer

@onready var counter_label: Label = $FlingCount/CounterPanel/CounterLabel
@onready var hole_label: Label = $HoleNum/CounterPanel/CounterLabel

func update_flingcount(flings :int):
	counter_label.text = str(flings)

func update_holenum(hole :int):
	hole_label.text = str(hole+1)
