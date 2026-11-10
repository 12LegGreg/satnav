extends Node

@export var satellite_scene: PackedScene
@export var station_scene: PackedScene
@export var default_satellite_type : SatelliteTypeData
@export var default_station_type : StationTypeData
@onready var world: Node = $SubViewport
@onready var satellite_network_manager: Node = $SubViewport/SatelliteNetworkManager
@onready var station_network_manager: Node = $SubViewport/StationNetworkManager
@onready var win_bar: ProgressBar = $UI/WinConditionBar

var game_over: bool = false

func _ready():
	Gameevents.satellite_destroyed.connect(check_loss_conditions)

func _process(delta: float) -> void:
	if game_over:
		return
	if Input.is_action_just_pressed("buy_satellite"):
		try_buy_satellite()
	update_coverage()
	if Input.is_action_just_pressed("buy_station"):
		try_buy_station()
		
func update_coverage():
	var filled_seats = 0
	var total_seats = 0
	for network in satellite_network_manager.get_children():
		total_seats += network.capacity
		filled_seats += network.members.size()
	if total_seats > 0:
		win_bar.value = (float(filled_seats) / float(total_seats)) * 100.0
		
func try_buy_satellite(chosen_type: SatelliteTypeData = null):
	var type_to_buy = chosen_type if chosen_type else default_satellite_type
	if Economy.money < type_to_buy.purchase_cost:
		print("Not enough money")
		return
	var target_network = find_available_satellite_network()
	if target_network == null:
		print ("No unlocked network has a free seat")
		return
	Economy.add_money(-type_to_buy.purchase_cost)
	var new_satellite = satellite_scene.instantiate()
	new_satellite.type_data = type_to_buy
	target_network.add_member(new_satellite)
	world.add_child(new_satellite)
	
func try_buy_station(chosen_type: StationTypeData = null):
	var type_to_buy = chosen_type if chosen_type else default_station_type
	if Economy.money < type_to_buy.purchase_cost:
		print("Not enough money")
		return
	var target_network = find_available_station_network()
	if target_network == null:
		print ("No unlocked network has a free seat")
		return
	Economy.add_money(-type_to_buy.purchase_cost)
	var new_station = station_scene.instantiate()
	new_station.type_data = type_to_buy
	target_network.add_member(new_station)
	world.add_child(new_station)
	
func find_available_satellite_network():
	for network in satellite_network_manager.get_children():
		if network.unlocked and network.members.size() < network.capacity:
			return network
	return null
	
func find_available_station_network():
	for network in station_network_manager.get_children():
		if network.unlocked and network.members.size() < network.capacity:
			return network
	return null

func check_loss_conditions():
	var total_satellites = 0
	for network in satellite_network_manager.get_children():
		total_satellites += network.members.size()
	if total_satellites == 0 and Economy.money < default_satellite_type.purchase_cost:	
		trigger_game_over("Bankrupt with no more satellites")

func trigger_game_over(reason: String):	
		game_over = true
		print("Game Over: ", reason)
		get_tree().paused = true
