extends Area2D

export var speed = 400 #How fast player will move (pixels/second)
var screen_size #Size of the game window
signal hit

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
	
#thing we need to manage in process func
	#inputs
	#movement
	#animations

func _process(delta):
	#inputs
	var velocity = Vector2() #Player movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x += -1
	if Input.is_action_pressed("ui_up"):
		velocity.y += -1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#movement
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)	
	position.y = clamp(position.y, 0, screen_size.y)
	
	#animations
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
	
	
	
	
	
	
	
	
	
