extends CanvasLayer

@export var shop_panel: Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	pass


func _on_shop_toggle_button_pressed() -> void:
	if shop_panel.visible:
		shop_panel.close_shop()
	else:
		shop_panel.open_shop()
		
