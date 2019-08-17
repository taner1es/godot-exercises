extends Area

func _process(delta):
	rotate_x(deg2rad(60 * delta))
	rotate_y(deg2rad(60 * delta))
	

func _on_Box_body_entered(body):
	if body is KinematicBody:
		queue_free()
