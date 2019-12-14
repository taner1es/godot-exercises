extends Area

signal coinCollected

func _ready():
	pass

func _physics_process(delta):
	rotate_y(deg2rad(3))

func _on_coin_body_entered(body):
	if body.name == "Ball":
		emit_signal("coinCollected")
		$Timer.start()
		$AnimationPlayer.play("bounce")

func _on_Timer_timeout():
	queue_free()
