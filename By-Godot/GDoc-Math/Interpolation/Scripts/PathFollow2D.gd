extends PathFollow2D

var speed = 100

func _physics_process(delta):
	self.offset += delta * speed

func _on_HSlider_value_changed(value):
	speed = value * 2
