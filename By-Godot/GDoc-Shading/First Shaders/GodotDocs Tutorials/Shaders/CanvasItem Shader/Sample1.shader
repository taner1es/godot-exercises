// SAMPLE 1: Assigning a new color
shader_type canvas_item;

void fragment(){
	//COLOR = vec4(0.4, 0.6, 0.9, 1.0);
	COLOR = vec4(UV, 0.5, 1.0);
}