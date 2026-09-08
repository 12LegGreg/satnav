extends Camera3D

var is_dragging: bool = false
var pitch: float = 0.0
var yaw: float = 0.0 
var camera_distance: float = 5.0
var sensitivity: float = 0.01
var zoom_speed: float = 0.5

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
		camera_distance = clamp(camera_distance, 1.5,20.0)

func _process(delta: float)-> void:
	position = Vector3(
		camera_distance * cos(pitch) * sin(yaw),
		camera_distance * sin(pitch),
		camera_distance * cos(pitch) * cos(yaw)
	)
	look_at (Vector3.ZERO, Vector3.UP)


	
		
		
