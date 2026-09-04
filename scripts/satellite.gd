extends Node3D

@export var orbit_radius: float = 2.6
@export var orbit_speed: float = 0.5
@export var orbit_axis: Vector3 = Vector3(0,1,0.3)
@export var money_per_orbit: int = 10
@export var max_fuel: float = 100.0
@export var fuel_consumption_rate: float = 0.5
@export var decay_rate: float = 0.05

var current_fuel: float = max_fuel
var angle_since_payout: float = 0.0
var orbit_angle: float = 0.0

func _process(delta: float) -> void:
	orbit_angle += orbit_speed * delta
	position = Vector3(orbit_radius,0,0).rotated(orbit_axis.normalized(),orbit_angle)
	angle_since_payout += orbit_speed * delta
	if angle_since_payout >= TAU:
		angle_since_payout -= TAU
		Economy.add_money(money_per_orbit)
		print(Economy.money)
		print(current_fuel)
	current_fuel -= fuel_consumption_rate * delta	
	current_fuel = clamp(current_fuel, 0, max_fuel)
	if current_fuel <= 0:
		orbit_radius -= decay_rate * delta
		if orbit_radius < 0.3:
			queue_free()
			
