extends Sprite

func _ready():
	var blue_value = 0.0
	material.set_shader_param("blue", blue_value)