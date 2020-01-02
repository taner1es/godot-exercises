extends Node2D

var Room = preload("res://Scenes/Room.tscn")
var Player = preload("res://Scenes/Character.tscn")
var font = preload("res://Assets/Font/varela_round_dynamicfont.tres")
onready var Map = $TileMap

var tile_size = 32 
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400 # horizontal spread
var cull = 0.5

var path: AStar # Astar(A*) pathfinding object
var start_room = null
var end_room = null
var play_mode: bool = false # Walking on the map or just doing generation
var player: Node = null

var rooms_ready:bool = false
var map_ready:bool = false

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
	
	rooms_ready = true
func _draw():
	if start_room:
		draw_string(font, start_room.position, "start", Color.white)
	if end_room:
		draw_string(font, end_room.position, "end", Color.white)
		
	if play_mode:
		return
	
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
	if event.is_action_pressed("ui_select"):
		if play_mode:
			player.queue_free()
			play_mode = false
		
		for room in $Rooms.get_children():
			room.queue_free()
			
		path = null
		start_room = null
		end_room = null
		rooms_ready = false
		map_ready = false
		make_rooms()
		Map.clear()
	
		
	if event.is_action_pressed("ui_focus_next"):
		if !rooms_ready:
			return
			
		make_map()
		
	if event.is_action_pressed("ui_cancel"):
		if !map_ready:
			return

		player = Player.instance()		
		add_child(player)
		
		play_mode = true
		player.position = start_room.position
		
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
	
func make_map():
	# Create a tilemap from the generated rooms and paths
	
	Map.clear()
	find_start_room()
	find_end_room()
	
	# Fill TileMap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents * 2)
		full_rect = full_rect.merge(r)
	
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(x, y, 1)
	
	# Carve the rooms
	var corridors = Array() # One corridor per connection
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor() 			# size of the room in tilespace
		var pos = Map.world_to_map(room.position) 			# position of the room in tilespace
		var ul = (room.position / tile_size).floor() - s 	# upper left position of the room in tilespace
		
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, 0)
		
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				
				carve_path(start, end)
		
		corridors.append(p)
		room.get_child(0).disabled = true
	
	map_ready = true

func carve_path(pos1: Vector2, pos2: Vector2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	
	# Choose an option either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 0)
		Map.set_cell(x, x_y.y + y_diff, 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 0)
		Map.set_cell(y_x.x + x_diff, y, 0)
	
func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x
	
	