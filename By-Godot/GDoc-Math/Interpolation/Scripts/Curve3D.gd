extends Node

var speed = 10

func _ready():
	$Viewport.size = Vector2(490, 250)
	$Sprite.flip_v = true

func _process(delta):
	$Sprite.texture = $Viewport.get_texture()
	$Viewport/Path/PathFollow.offset += speed * delta

func _on_HSlider2_value_changed(value):
	speed = value / 4
