extends Node

func _ready():
	set_camera_limits()
	Input.set_custom_mouse_cursor(load("res://Assets/Textures/crossair_black.png"), Input.CURSOR_ARROW, Vector2(16, 16))
	$Player.map = $Ground

func set_camera_limits():
	var map_limits = $Ground/TileMap.get_used_rect()
	var map_cellsize = $Ground/TileMap.cell_size

	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

	

func _on_Tank_shoot(bullet, _position, _direction, _target):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, _target)


func _on_Player_dead():
	GLOBALS.restart()
