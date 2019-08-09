extends Node

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var level = 0

func _ready():
	randomize()
	$HUD.hide()
	
func new_game():
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_Captured")
	player.connect("died", self, "_on_Jumper_Died")
	spawn_circle($StartPosition.position)
	if settings.enable_music:
		$Music.play()
	$HUD.show()
	$HUD.show_message("Go!")
	
func spawn_circle(_position = null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x,y)
	add_child(c)
	c.init(_position)
	
func _on_Jumper_Captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	score += 1
	$HUD.update_score(score)
	
func _on_Jumper_Died():
	get_tree().call_group("circles", "implode")
	$Screens.game_over()
	if settings.enable_music:
		$Music.stop()
	$HUD.hide()