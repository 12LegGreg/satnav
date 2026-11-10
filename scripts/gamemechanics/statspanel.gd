extends PanelContainer

@export var satellite_network_manager: Node
@export var station_network_manager: Node
@export var refresh_interval: float = 0.25

@onready var list_container: VBoxContainer = $ScrollContainer/VBoxContainer

var refresh_timer: float = 0.0
var row_nodes: Dictionary = {}  # entity -> Dictionary of that entity's UI node references

func _process(delta: float) -> void:
	refresh_timer -= delta
	if refresh_timer <= 0.0:
		refresh_timer = refresh_interval
		sync_rows()
	update_row_text()

func get_all_entities() -> Array:
	var entities: Array = []
	for network in satellite_network_manager.get_children():
		entities.append_array(network.members)
	for network in station_network_manager.get_children():
		entities.append_array(network.members)
	return entities

func sync_rows() -> void:
	var current_entities = get_all_entities()
	for entity in row_nodes.keys():
		if not is_instance_valid(entity) or not current_entities.has(entity):
			row_nodes[entity]["panel"].queue_free()
			row_nodes.erase(entity)
	for entity in current_entities:
		if not row_nodes.has(entity):
			row_nodes[entity] = create_entity_row()

func create_entity_row() -> Dictionary:
	var panel = PanelContainer.new()
	list_container.add_child(panel)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	var title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(title_label)

	var hp_bar = ProgressBar.new()
	hp_bar.custom_minimum_size = Vector2(0, 14)
	vbox.add_child(hp_bar)

	var fuel_bar = ProgressBar.new()
	fuel_bar.custom_minimum_size = Vector2(0, 14)
	vbox.add_child(fuel_bar)

	var stats_label = Label.new()
	stats_label.add_theme_font_size_override("font_size", 11)
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(stats_label)

	return {
		"panel": panel,
		"title": title_label,
		"hp_bar": hp_bar,
		"fuel_bar": fuel_bar,
		"stats_label": stats_label,
	}

func update_row_text() -> void:
	for entity in row_nodes.keys():
		if not is_instance_valid(entity):
			continue
		var refs = row_nodes[entity]
		var type_data = entity.type_data

		refs["title"].text = type_data.type_name if type_data else "Unknown"

		refs["hp_bar"].max_value = type_data.max_hp if type_data else 1
		refs["hp_bar"].value = entity.current_hp

		refs["fuel_bar"].max_value = type_data.max_fuel if type_data else 1
		refs["fuel_bar"].value = entity.current_fuel

		refs["stats_label"].text = build_stat_line(type_data) if type_data else ""

func build_stat_line(type_data: Resource) -> String:
	var parts: Array = []
	var money = type_data.get("money_per_orbit")
	if money != null:
		parts.append("$%d/orbit" % money)
	var science = type_data.get("science_per_orbit")
	if science != null:
		parts.append("+%d sci/orbit" % science)
	var speed = type_data.get("orbit_speed")
	if speed != null:
		parts.append("Speed %.1f" % speed)
	return " | ".join(parts)
