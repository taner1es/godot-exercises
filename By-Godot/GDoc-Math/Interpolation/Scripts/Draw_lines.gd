extends Control


export(NodePath) var bezier

onready var bezier_node = get_node(bezier)


var points

var update_lines = false

func _ready():
	
	points = PoolVector2Array()
	if bezier_node:
		for point in bezier_node.get_children():
			print(point.position)
			if point.is_class("Position2D"):
				points.append(point.position)

func _draw():
	if points:
		draw_polyline(points, Color.red, 1.0, true)

func _process(delta):
	if update_lines:
		update()
		update_lines = false

func _on_ColorRect_point_dragged():
	if not update_lines:
		update_lines = true
		
	points = PoolVector2Array()
	for point in bezier_node.get_children():
		if point.is_class("Position2D"):
			points.append(point.position)
