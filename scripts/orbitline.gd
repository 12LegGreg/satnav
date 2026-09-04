extends MeshInstance3D

@export var target_satellite: Node
@export var dash_length: float = 0.1
@export var gap_length: float = 0.1

var line_mesh: ImmediateMesh

func _ready() -> void:
	line_mesh = ImmediateMesh.new()
	self.mesh = line_mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	rebuild_mesh()

func _process(delta:float):
	rebuild_mesh()

func rebuild_mesh():
	if not is_instance_valid(target_satellite):
		queue_free()
		return

	var orbit_radius = target_satellite.orbit_radius
	var orbit_axis = target_satellite.orbit_axis
	
	line_mesh.clear_surfaces()
	line_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	var angle := 0.0
	while angle < TAU:
		var start_point = Vector3(orbit_radius, 0, 0).rotated(orbit_axis.normalized(), angle)
		var end_point = Vector3(orbit_radius, 0, 0).rotated(orbit_axis.normalized(), angle + dash_length)
		line_mesh.surface_add_vertex(start_point)
		line_mesh.surface_add_vertex(end_point)
		angle += dash_length + gap_length
	line_mesh.surface_end()
