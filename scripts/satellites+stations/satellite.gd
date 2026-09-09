extends Node3D

@export var type_data: SatelliteTypeData
@export var orbit_axis: Vector3 = Vector3(0,1,0.3)

var assigned_network: Node = null
var current_fuel: float
var current_hp: float
var orbit_radius: float
var angle_since_payout: float = 0.0
var orbit_angle: float = 0.0


func _ready():
	current_fuel = type_data.max_fuel
	current_hp = type_data.max_hp
	orbit_radius = type_data.orbit_radius

func _process(delta: float) -> void:
	orbit_angle += type_data.orbit_speed * delta
	var base_point = get_perpendicular_vector(orbit_axis) * orbit_radius
	position = base_point.rotated(orbit_axis.normalized(), orbit_angle)
	angle_since_payout += type_data.orbit_speed * delta
	if angle_since_payout >= TAU:
		angle_since_payout -= TAU
		Economy.add_money(type_data.money_per_orbit)
		print(Economy.money)
		print(current_fuel)
	current_fuel -= type_data.fuel_consumption_rate * delta	
	current_fuel = clamp(current_fuel, 0, type_data.max_fuel)
	if current_fuel <= 0:
		orbit_radius -= type_data.decay_rate * delta
		if orbit_radius < 2.6:
			destroy()
			
func take_damage(amount: float):
	current_hp -= amount
	current_hp = clamp(current_hp, 0, type_data.max_hp)
	if current_hp <= 0:
		destroy()
		
func destroy():
	if assigned_network:
		assigned_network.remove_satellite(self)
	Gameevents.satellite_destroyed.emit()
	queue_free()

func get_perpendicular_vector(axis: Vector3) -> Vector3:
	var reference = Vector3.UP
	if abs(axis.normalized().dot(Vector3.UP)) > 0.99:
		reference = Vector3.RIGHT
	return axis.normalized().cross(reference).normalized()
			
