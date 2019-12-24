extends CanvasLayer

var bar_red = preload("res://Assets/Textures/barHorizontal_red_mid 200.png")
var bar_green = preload("res://Assets/Textures/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://Assets/Textures/barHorizontal_yellow_mid 200.png")
var bar_texture

func update_ammo(value):
	$MarginContainer/HBoxContainer/AmmoGauge.value = value

func update_healthbar(value):
	bar_texture = bar_green
	if value < 60:
		bar_texture = bar_yellow
	if value < 25:
		bar_texture = bar_red
	
	$MarginContainer/HBoxContainer/HealthBar.texture_progress = bar_texture
	$MarginContainer/HBoxContainer/HealthBar/Tween.interpolate_property($MarginContainer/HBoxContainer/HealthBar, 
			"value", $MarginContainer/HBoxContainer/HealthBar.value, value,
			.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$MarginContainer/HBoxContainer/HealthBar/Tween.start()
	$AnimationPlayer.play("Healthbar_flash")
	#$MarginContainer/HBoxContainer/HealthBar.value = value
