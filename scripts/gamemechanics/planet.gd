extends Node3D

@onready var planet_mesh: MeshInstance3D = $MeshInstance3D
@export var planet_radius: float = 4

func _ready():
	planet_mesh.mesh.radius = planet_radius
	planet_mesh.mesh.height = planet_radius * 2
