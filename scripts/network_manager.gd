extends Node

@export var network_scene: PackedScene
@export var network_count: int = 10
@export var base_orbit_axis: Vector3 = Vector3(0, 1, 0.3)
@export var orbit_radius: float = 2.6

func _ready() -> void:
	for i in range(network_count):
		var new_network = network_scene.instantiate()
		var angle = i * (TAU / network_count)
		new_network.orbit_axis = base_orbit_axis.rotated(Vector3.UP, angle)
		new_network.orbit_radius = orbit_radius
		new_network.unlocked = (i == 0)
		add_child(new_network)
