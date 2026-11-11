extends Control

@export var main: Node
@onready var sat_network_button: Button = $ShopWindow/MarginContainer/VBoxContainer/CategoryTabs/Networks/VBoxContainer/UnlockSatNetwork
@onready var stn_network_button: Button = $ShopWindow/MarginContainer/VBoxContainer/CategoryTabs/Networks/VBoxContainer/UnlockStnNetwork
@onready var refuel_all_button: Button = $"ShopWindow/MarginContainer/VBoxContainer/CategoryTabs/Refuel & Repairs/RefuelAllButton"
func _ready() -> void:
	visible = false

func open_shop() -> void:
	visible = true
	get_tree().paused = true
	refresh_buttons()
	
func refresh_buttons():
	var fuel_cost = main.get_refuel_all_cost()
	var sat_network_cost = main.satellite_network_manager.get_network_unlock_cost()
	var stn_network_cost = main.station_network_manager.get_network_unlock_cost()
	refuel_all_button.text = "Refuel All - $%.1f" % main.get_refuel_all_cost()
	refuel_all_button.disabled = not Economy.can_afford(fuel_cost)
	sat_network_button.text = "Unlock New Satellite Network - $%.1f" % main.satellite_network_manager.get_network_unlock_cost()
	sat_network_button.disabled = not Science.can_afford(sat_network_cost)
	stn_network_button.text = "Unlock New Station Network - $%.1f" % main.station_network_manager.get_network_unlock_cost()
	stn_network_button.disabled = not Science.can_afford(stn_network_cost)
	
func close_shop() -> void:
	visible = false
	if not main.game_over:
		get_tree().paused = false

func _on_close_button_pressed() -> void:
	close_shop()

func _on_refuel_all_button_pressed() -> void:
	main.refuel_all()
	refresh_buttons()

func _on_unlock_sat_network_pressed() -> void:
	main.buy_network_unlock(main.satellite_network_manager)
	refresh_buttons()

func _on_unlock_stn_network_pressed() -> void:
	main.buy_network_unlock(main.station_network_manager)
	refresh_buttons()
