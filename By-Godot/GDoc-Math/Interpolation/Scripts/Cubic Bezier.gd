extends Node

export var t = 0.0
export var r = 0.0
export var reverse = false


func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var q2 = p2.linear_interpolate(p3, t)
	
	var r0 = q0.linear_interpolate(q1, t)
	var r1 = q1.linear_interpolate(q2, t)
	
	r = r0.linear_interpolate(r1, t)
	
	return r
	
func move_cubic(delta):
	if t < 1.0 && not reverse:
		t += delta * 0.4;
		$Sprite.position = _cubic_bezier($P0.position, $P1.position, $P2.position, $P3.position, t)
	elif t > 0.0:
		reverse = true
		t -= delta * 0.4;
		$Sprite.position = _cubic_bezier($P0.position, $P1.position, $P2.position, $P3.position, t)
	else:
		reverse = false
		
func _physics_process(delta):
	move_cubic(delta)
	
func _on_CheckBox2_toggled(button_pressed):
	$P0/ColorRect.visible = not button_pressed
	$P1/ColorRect.visible = not button_pressed
	$P2/ColorRect.visible = not button_pressed
	$P3/ColorRect.visible = not button_pressed
	$"../UI/Draw_lines_2".visible = not button_pressed
