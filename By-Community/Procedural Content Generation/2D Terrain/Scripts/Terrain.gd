extends Node

export var num_hills = 2
export var slice = 10
export var hill_range = 100

var screen_size
var terrain = Array()
var texture_grass = preload("res://Assets/Textures/grass.png")

func _ready():
	randomize()
	screen_size = get_viewport().get_visible_rect().size
	terrain = Array()
	var start_y = screen_size.y * 3/4 + (-hill_range + randi() % hill_range*2)
	terrain.append(Vector2(0, start_y))
	add_hills()
	$Runner.position.x += screen_size.x / 2
	
func _process(delta):
	if terrain[-1].x < $Runner.position.x + screen_size.x / 2:
		add_hills()
	
func add_hills():
	var hill_width = screen_size.x / num_hills
	var hill_slices = hill_width / slice
	var start = terrain[-1]
	var poly = PoolVector2Array()
	
	poly.append(Vector2(start.x, screen_size.y+20))
	
	for i in range(num_hills):
		var height = randi() % hill_range
		start.y -= height
		for j in range(0, hill_slices):
			var hill_point = Vector2()
			hill_point.x = start.x + j * slice + hill_width * i
			hill_point.y = start.y + height * cos(2 * PI / hill_slices * j)
			#$Line2D.add_point(hill_point)
			terrain.append(hill_point)
			poly.append(hill_point)
		start.y += height
	
	var shape = CollisionPolygon2D.new()
	var ground = Polygon2D.new()
	
	$StaticBody2D.add_child(shape)
	
	poly.append(Vector2(terrain[-1].x, screen_size.y+20))
	
	shape.polygon = poly
	ground.polygon = poly
	
	ground.texture = texture_grass
	ground.name = "Ground"
	
	$GroundParent.add_child(ground)