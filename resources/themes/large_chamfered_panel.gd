extends StyleBox
class_name large_chamfered_box

@export var bg_color: Color = Color(0.04, 0.08, 0.14, 0.8)
@export var border_color: Color = Color(0.451, 0.755, 0.883, 1.0)
@export var border_width: float = 2.0
@export var chamfer_size: float = 12.0

func _get_points(rect: Rect2, inset: float) -> PackedVector2Array:
	var r = rect.grow(-inset)
	var c = chamfer_size
	return PackedVector2Array([
		Vector2(r.position.x + c, r.position.y),
		Vector2(r.end.x - c, r.position.y),
		Vector2(r.end.x, r.position.y + c),
		Vector2(r.end.x, r.end.y - c),
		Vector2(r.end.x - c, r.end.y),
		Vector2(r.position.x + c, r.end.y),
		Vector2(r.position.x, r.end.y - c),
		Vector2(r.position.x, r.position.y + c),
	])

func _draw(to_canvas_item: RID, rect: Rect2) -> void:
	var outer = _get_points(rect, 0.0)
	RenderingServer.canvas_item_add_polygon(to_canvas_item, outer, PackedColorArray([border_color]))
	var inner = _get_points(rect, border_width)
	RenderingServer.canvas_item_add_polygon(to_canvas_item, inner, PackedColorArray([bg_color]))
