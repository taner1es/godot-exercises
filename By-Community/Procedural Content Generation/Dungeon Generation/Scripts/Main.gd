extends Node2D

var Room = preload("res://Scenes/Room.tscn")

var tile_size = 32 
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400 # horizontal spread
var cull = 0.5

var path: AStar # Astar(A*) pathfinding object

func _ready():
	randomize()
	make_rooms()
	
func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size) #width
		var h = min_size + randi() % (max_size - min_size) #height
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), "timeout")
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
	
	yield(get_tree(), "idle_frame")
	# generate a minimum spanning tree connecting the rooms
	path = find_mst(room_positions)
	
func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size*2), Color("#6eff00"), false)
		
	if path:
		for p in path.get_points(): # each position
			for c in path.get_point_connections(p): # each connection
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 15, 0), 15, true)
			
		
func _process(delta):
	update()
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		for room in $Rooms.get_children():
			room.queue_free()
		path = null
		make_rooms()
		
		
	
func find_mst(nodes: Array):
	# Prim's Algorithm
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
		
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF 	# minimum distance
		var min_p = null 	# minimum position
		var p = null 		# current position
		
		# Loop through points the path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through remaining nodes
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
		
	return path
		