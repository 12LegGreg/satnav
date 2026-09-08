extends MeshInstance3D

@export var dash_length: float = 0.1
@export var gap_length: float = 0.1
@export var orbit_axis: Vector3 = Vector3(0,1,0.3)
@export var orbit_radius: float = 2.8
@export var capacity: int = 5
@export var unlocked: bool = true

var satellites: Array = []
var line_mesh: ImmediateMesh
var ring_material: StandardMaterial3D

func _ready() -> void:
	line_mesh = ImmediateMesh.new()
	self.mesh = line_mesh
	ring_material = StandardMaterial3D.new()
	ring_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	update_visual_state()
	rebuild_mesh()

func update_visual_state():
	if unlocked:
		ring_material.albedo_color = Color.WHITE
	else:
		ring_material.albedo_color = Color(0.4, 0.4, 0.4)

func _process(delta:float):
	rebuild_mesh()

func rebuild_mesh() -> void:
	var base_point = get_perpendicular_vector(orbit_axis) * orbit_radius
	line_mesh.clear_surfaces()
	line_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	var angle := 0.0
	while angle < TAU:
		var start_point = base_point.rotated(orbit_axis.normalized(), angle)
		var end_point = base_point.rotated(orbit_axis.normalized(), angle + dash_length)
		line_mesh.surface_add_vertex(start_point)
		line_mesh.surface_add_vertex(end_point)
		angle += dash_length + gap_length
	line_mesh.surface_end()
	line_mesh.surface_set_material(0, ring_material)
	
func get_perpendicular_vector(axis: Vector3) -> Vector3:
	var reference = Vector3.UP
	if abs(axis.normalized().dot(Vector3.UP)) > 0.99:
		reference = Vector3.RIGHT
	return axis.normalized().cross(reference).normalized()

func add_satellite(satellite: Node) -> bool:
	if not unlocked or satellites.size() >= capacity:
		return false
	satellite.orbit_axis = orbit_axis
	satellite.orbit_radius = orbit_radius
	satellite.assigned_network = self
	satellites.append(satellite)
	redistribute_satellites()
	return true

func redistribute_satellites() -> void:
	var count = satellites.size()
	if count == 0:
		return
	for i in range(count):
		satellites[i].orbit_angle = i * (TAU / count)
		
func remove_satellite(satellite: Node) -> void:
	satellites.erase(satellite)
	redistribute_satellites()
