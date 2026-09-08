extends Label

func _ready():
	text = "$%d" % Economy.money
	Economy.money_changed.connect(_on_money_changed)

func _on_money_changed(new_amount: int):
	text = "$%d" % new_amount
