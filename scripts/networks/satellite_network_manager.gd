extends Node
@export var satellite_network_scene: PackedScene
@export var orbit_radius: float = 2.8
@export var meridian_count: int = 8
@export var second_meridian_count: int = 8
@export var inclination_steps: int = 3
@export var inclination_density: int = 6

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
	var new_network = satellite_network_scene.instantiate()
	new_network.orbit_axis = axis
	new_network.orbit_radius = orbit_radius
	new_network.unlocked = is_unlocked
	add_child(new_network)
