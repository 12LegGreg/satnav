extends Label

func _ready():
	text = "Science: %d" % Science.science
	Science.science_changed.connect(_on_science_changed)

func _on_science_changed(new_amount: int):
	text = "Science: %d" % new_amount
