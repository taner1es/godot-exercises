extends Node

export var t = 0.0
export var r = 0.0
export var reverse = false


func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	
	r = q0.linear_interpolate(q1, t)
	
	return r
	
func move_quadratic(delta):
	if t < 1.0 && not reverse:
		t += delta * 0.4;
		$Sprite1.position = _quadratic_bezier($P0.position, $P1.position, $P2.position, t)
	elif t > 0.0:
		reverse = true
		t -= delta * 0.4;
		$Sprite1.position = _quadratic_bezier($P0.position, $P1.position, $P2.position, t)
	else:
		reverse = false
		
func _physics_process(delta):
	move_quadratic(delta)

func _on_CheckBox_toggled(button_pressed):
	$P0/ColorRect.visible = not button_pressed
	$P1/ColorRect.visible = not button_pressed
	$P2/ColorRect.visible = not button_pressed
	$"../UI/Draw_lines_1".visible = not button_pressed
