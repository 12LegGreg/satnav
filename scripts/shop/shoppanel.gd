extends Control

@export var main: Node

func _ready() -> void:
	visible = false

func open_shop() -> void:
	visible = true
	get_tree().paused = true

func close_shop() -> void:
	visible = false
	if not main.game_over:
		get_tree().paused = false

func _on_close_button_pressed() -> void:
	close_shop()

func _on_refuel_all_button_pressed() -> void:
	main.refuel_all()
	


func _on_unlock_sat_network_pressed() -> void:
	main.buy_network_unlock(main.satellite_network_manager)

func _on_unlock_stn_network_pressed() -> void:
	main.buy_network_unlock(main.station_network_manager)
