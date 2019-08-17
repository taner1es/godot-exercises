extends Area2D

var speed = 100
var direction = Vector2()
var width
var height
var hit = false
var loose = false
var clicks = 0

func _ready():
	position = get_viewport_rect().size / 2
	direction.x = rand_range(-1, 1)
	direction.y = rand_range(-1, 1)
	direction = direction.normalized()
	
	width = get_viewport_rect().size.x
	height = get_viewport_rect().size.y
	
func _process(delta):
	position += direction * speed * delta
	
	if position.x < 0 or position.x > width:
		direction.x *= -1
	if position.y < 0 or position.y > height:
		direction.y *= -1
		
func _on_UFO_input_event(viewport, event, shape_idx):
	if loose:
		return
		
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		direction.x = rand_range(-1, 1)
		direction.y = rand_range(-1, 1)
		direction = direction.normalized()
		position.x = rand_range(1, width-1)
		position.y = rand_range(1, height-1)
		speed += 5
		hit = true
		$HitSound.play()