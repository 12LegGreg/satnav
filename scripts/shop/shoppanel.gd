extends Control

func _ready() -> void:
	visible = false

func open_shop() -> void:
	visible = true
	get_tree().paused = true

func close_shop() -> void:
	visible = false
	get_tree().paused = false

func _on_close_button_pressed() -> void:
	close_shop()
