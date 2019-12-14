// SAMPLE 4: First Vertex Function

// Most important variable is "VERTEX"
// "VERTEX" is vec2 to refer local coordination

shader_type canvas_item;

void vertex(){
	// Applies offset through on the "x coordinate"
	//VERTEX += vec2(10.0, 0.0);
	
	// Animates with "TIME" built-in variable
	VERTEX += vec2(cos(TIME) * 100.0, sin(TIME) * 100.0);
}