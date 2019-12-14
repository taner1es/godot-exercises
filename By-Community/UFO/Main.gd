extends Node2D

var hit = false

func _ready():
	$Control/MarginContainer/LoseLabel.hide()
func _process(delta):
	if !$UFO.hit and hit:
		print("lose")
		$UFO.loose = true
		$Control/MarginContainer/LoseLabel.show()
	if $UFO.hit:
		$UFO.clicks += 1
		$Control/MarginContainer/ClicksLabel.text = "Clicks: " + str($UFO.clicks)
	$UFO.hit = false
	hit = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		hit = true