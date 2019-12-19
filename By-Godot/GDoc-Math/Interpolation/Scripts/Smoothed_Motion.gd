extends CanvasItem

const FOLLOW_SPEED = 4.0

func _physics_process(delta):
    var mouse_pos = get_local_mouse_position()

    $Sprite.position = $Sprite.position.linear_interpolate(mouse_pos, delta * FOLLOW_SPEED)