extends Node

@export var satellite_scene: PackedScene
@export var satellite_cost: int = 1
@onready var world: Node = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("buy_satellite"):
		if Economy.money >= satellite_cost:
			Economy.add_money(-satellite_cost)
			var new_satellite = satellite_scene.instantiate()
			world.add_child(new_satellite)
		else:
			print("Not enough money to buy a satellite")
