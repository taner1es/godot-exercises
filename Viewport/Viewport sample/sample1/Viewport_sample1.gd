extends Node

var viewport = null
var viewport_sprite = null

var window_size = Vector2(0, 0)

func _ready():
	window_size = OS.window_size
	viewport = $Viewport
	viewport_sprite = $Viewport_Sprite
	viewport.size = window_size
	
	viewport_sprite.flip_v = true
	viewport_sprite.position = window_size / 2
	viewport_sprite.texture = viewport.get_texture()
	
	set_process(true)
	
func _process(delta):
	if OS.window_size != window_size:
		print("window resized")
		window_size = OS.window_size
		viewport.size = window_size
		viewport_sprite.texture = viewport.get_texture()