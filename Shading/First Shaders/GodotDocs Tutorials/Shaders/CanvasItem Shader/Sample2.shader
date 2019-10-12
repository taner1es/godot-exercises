// SAMPLE 2: Using "TEXTURE" built-in

shader_type canvas_item;

void fragment(){
	// this shader will result in an all white rectangle
	//because we should apply texture manually if we override
	//the fragment function while a texture in use.
	//COLOR.b = 1.0;
	
	// this shader will fix the white rectangle issue
	COLOR = texture(TEXTURE, UV); //read from texture
	COLOR.b = 1.0; //set blue channel to 1.0
}
