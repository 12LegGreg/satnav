extends Camera3D

@export var planet: Node3D

var is_dragging: bool = false
var pitch: float = 0.0
var yaw: float = 0.0 
@onready var camera_distance: float = planet.planet_radius * 3
var sensitivity: float = 0.01
@onready var zoom_speed: float = planet.planet_radius * 0.25

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.is_pressed()
	
	if event is InputEventMouseMotion and is_dragging:
		yaw -= event.relative.x * sensitivity
		pitch += event.relative.y * sensitivity
		pitch = clamp(pitch, -PI/2 + 0.1, PI/2 -0.1)
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_distance += zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_distance -= zoom_speed
		camera_distance = clamp(camera_distance, planet.planet_radius * 1, planet.planet_radius * 8)

func _process(delta: float)-> void:
	position = Vector3(
		camera_distance * cos(pitch) * sin(yaw),
		camera_distance * sin(pitch),
		camera_distance * cos(pitch) * cos(yaw)
	)
	look_at (Vector3.ZERO, Vector3.UP)


	
		
		
