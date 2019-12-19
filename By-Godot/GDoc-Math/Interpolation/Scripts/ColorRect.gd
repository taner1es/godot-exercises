extends ColorRect

var inside = false
export(NodePath) var panel_path

export onready var panel = get_node(panel_path)
onready var parent = $".."

signal point_dragged

func _on_ColorRect_mouse_entered():
	inside = true
	
func _on_ColorRect_mouse_exited():
	inside = false
	
	
func _physics_process(delta):
	if inside && Input.is_action_pressed("click_left"):
		var mouse = get_global_mouse_position()
		parent.position = Vector2(clamp(mouse.x, panel.rect_position.x, panel.rect_position.x + panel.rect_size.x),
								clamp(mouse.y, panel.rect_position.y, panel.rect_position.y + panel.rect_size.y))
		
		print("mouse.position = (" + String(mouse.x) + ", " + String(mouse.y) + ")")
		print(String(parent.name) + ".position = " + String(parent.position))
		emit_signal("point_dragged")


