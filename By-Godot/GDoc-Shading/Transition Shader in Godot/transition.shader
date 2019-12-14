shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

uniform float smooth_size : hint_range(0.0, 1.0);

void fragment(){
	float value = texture(mask, UV).r;
	
	// first way, no smoothness
	// ------
//	if (value < cutoff){
//		COLOR = vec4(COLOR.rgb, 0.0);
//	}else{
//		COLOR = vec4(COLOR.rgb, 1.0);
//	}
	// ------
	
	// second way, no smoothness
	// ------
//	float alpha = step(value, cutoff);
//	COLOR = vec4(COLOR.rgb, alpha);
	// ------
	
	// third way, smoothy
	// ------
//	if (value < cutoff){
//		COLOR = vec4(COLOR.rgb, 1.0);
//	}else if (value < cutoff + 0.1){
//		COLOR = vec4(COLOR.rgb, (cutoff + 0.1 - value) / 0.1);
//	}else{
//		COLOR = vec4(COLOR.rgb, 0.0);
//	}
	// ------
	
	// forth way, smoothy
	// ------
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	COLOR = vec4(COLOR.rgb, alpha);	
	// ------
	
}