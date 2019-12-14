// SAMPLE 3: Uniform input
shader_type canvas_item;

// Defining a uniform
uniform float size;
uniform float blue = 1.0; // define and assign a default value

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.b = blue; // this value will be overridden through script to 0.0
	
	// Now we can override the blue value inside the editor,
	//inspector/CanvasItem/Material/Shader/Shader Param section
	//or we can override from the script
}


