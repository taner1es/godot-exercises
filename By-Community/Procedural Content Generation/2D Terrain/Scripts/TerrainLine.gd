extends Line2D

export var displacement = 100 # offset value to midpoint
export var iterations = 10 # multiplier to the lengh
export var height = 250 # starting point
export var smooth: = 1.1
var current_displacement

func _ready():
	randomize()
	$Polygon2D.color = default_color
	init_line()

func init_line():
	randomize()
	var screen_size = get_viewport().get_visible_rect().size
	current_displacement = displacement
	points = PoolVector2Array()
	var start = Vector2(0, rand_range(height - displacement, height + displacement))
	var end = Vector2(screen_size.x, rand_range(height - displacement, height + displacement))
	
	add_point(start)
	add_point(end)
	for i in range(iterations):
		add_points()
		
	var p = PoolVector2Array()
	p.append_array(points)
	p.append(Vector2(screen_size.x, screen_size.y))
	p.append(Vector2(0, screen_size.y))
	$Polygon2D.polygon = p
	
func add_points():
	var old_points = points
	points = PoolVector2Array()
	for i in range(old_points.size() -1):
		var midpoint = (old_points[i] + old_points[i+1]) / 2
		midpoint.y += current_displacement * pow(-1, randi() %2)
		add_point(old_points[i])
		add_point(midpoint)
	add_point(old_points[old_points.size() - 1])
	current_displacement *= pow(2.0, -smooth)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		init_line()