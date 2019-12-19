extends Label

onready var qb = get_tree().get_root().get_node("Node/Cubic Bezier")
onready var p0 = get_tree().get_root().get_node("Node/Cubic Bezier/P0")
onready var p1 = get_tree().get_root().get_node("Node/Cubic Bezier/P1")
onready var p2 = get_tree().get_root().get_node("Node/Cubic Bezier/P2")
onready var p3 = get_tree().get_root().get_node("Node/Cubic Bezier/P3")


func _physics_process(delta):
	text =  "p1_pos: " 	+ String(p0.position) 	+ "\n"
	text += "p2_pos: " 	+ String(p1.position) 	+ "\n"
	text += "p3_pos: " 	+ String(p2.position) 	+ "\n"
	text += "p4_pos: " 	+ String(p3.position) 	+ "\n"
	text += "t: " 		+ String(qb.t)			+ "\n"
	text += "r: " 		+ String(qb.r)