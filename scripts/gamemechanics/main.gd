extends Node

@export var satellite_scene: PackedScene
@export var satellite_cost: int = 10
@export var station_scene: PackedScene
@export var station_cost: int = 50
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
		filled_seats += network.satellites.size()
	if total_seats > 0:
		win_bar.value = (float(filled_seats) / float(total_seats)) * 100.0
		
func try_buy_satellite():
	if Economy.money < satellite_cost:
		print("Not enough money")
		return
	var target_network = find_available_satellite_network()
	if target_network == null:
		print ("No unlocked network has a free seat")
		return
	Economy.add_money(-satellite_cost)
	var new_satellite = satellite_scene.instantiate()
	target_network.add_satellite(new_satellite)
	world.add_child(new_satellite)
	
func try_buy_station():
	if Economy.money < station_cost:
		print("Not enough money")
		return
	var target_network = find_available_station_network()
	if target_network == null:
		print ("No unlocked network has a free seat")
		return
	Economy.add_money(-station_cost)
	var new_station = station_scene.instantiate()
	target_network.add_station(new_station)
	world.add_child(new_station)
	
func find_available_satellite_network():
	for network in satellite_network_manager.get_children():
		if network.unlocked and network.satellites.size() < network.capacity:
			return network
	return null
	
func find_available_station_network():
	for network in station_network_manager.get_children():
		if network.unlocked and network.station.size() < network.capacity:
			return network
	return null

func check_loss_conditions():
	var total_satellites = 0
	for network in satellite_network_manager.get_children():
		total_satellites += network.satellites.size()
	if total_satellites == 0 and Economy.money < satellite_cost:	
		trigger_game_over("Bankrupt with no more satellites")

func trigger_game_over(reason: String):	
		game_over = true
		print("Game Over: ", reason)
		get_tree().paused = true
