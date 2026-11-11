extends Node

@export var network_scene: PackedScene
@export var meridian_count: int
@export var second_meridian_count: int
@export var inclination_steps: int
@export var inclination_density: int
@export var planet: Node3D
@export var altitude_fraction: float
@export var network_unlock_base_cost: float
@export var network_unlock_cost_increase: float
var networks_unlocked: int = 0

func _ready() -> void:
	var axes: Array = []

	for i in range(meridian_count):
		var angle = i * (PI / meridian_count)
		axes.append(Vector3(cos(angle), 0, sin(angle)))

	for i in range(second_meridian_count):
		var angle = i * (PI / second_meridian_count)
		axes.append(Vector3(0, cos(angle), sin(angle)))

	for i in range(1, inclination_steps + 1):
		var inclination = deg_to_rad(90.0 * i / (inclination_steps + 1))
		var copies_this_band = max(1, round(inclination_density * sin(inclination)))
		for j in range(copies_this_band):
			var azimuth = j * (TAU / copies_this_band)
			axes.append(Vector3(
				sin(inclination) * cos(azimuth),
				cos(inclination),
				sin(inclination) * sin(azimuth)
			))

	var unlocked_index = randi() % axes.size()
	for i in range(axes.size()):
		spawn_network(axes[i], i == unlocked_index)

func spawn_network(axis: Vector3, is_unlocked: bool) -> void:
	var new_network = network_scene.instantiate()
	new_network.orbit_axis = axis
	new_network.orbit_radius = planet.planet_radius * altitude_fraction
	new_network.planet_radius = planet.planet_radius
	new_network.unlocked = is_unlocked
	add_child(new_network)
	
func get_network_unlock_cost() -> float:
	return network_unlock_base_cost + network_unlock_cost_increase * networks_unlocked

func get_locked_networks() -> Array:
	var locked: Array = []
	for network in get_children():
		if not network.unlocked:
			locked.append(network)
	return locked

func has_locked_networks() -> bool:
	return not get_locked_networks().is_empty()

func unlock_random_network() -> bool:
	var locked: Array = get_locked_networks()
	if locked.is_empty():
		return false
	var chosen_network = locked.pick_random()
	chosen_network.unlocked = true
	networks_unlocked += 1
	return true
	
