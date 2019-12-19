extends Node

var t = 0.0

func _physics_process(delta):
	if t < 1.0:
		t += delta * 0.4
		print(t)
		
		if $Sprite: #intended for 2D 
#			$Sprite.position = $A.position.linear_interpolate($B.position, t)
			$Sprite.transform = $A.transform.interpolate_with($B.transform, t)
		elif $MeshInstance: #intended for 3D 
#			$MeshInstance.translation = $A.translation.linear_interpolate($B.translation, t)
			$MeshInstance.transform = $A.transform.interpolate_with($B.transform, t)