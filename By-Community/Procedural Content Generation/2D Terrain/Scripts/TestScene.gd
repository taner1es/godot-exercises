extends Control

func _ready():
	$TerrainLine.default_color = Color.red
	$TerrainLine2.default_color = Color.green
	$TerrainLine3.default_color = Color.blue
	
	$TerrainLine/Polygon2D.color = Color.red
	$TerrainLine2/Polygon2D.color = Color.green
	$TerrainLine3/Polygon2D.color = Color.blue
	