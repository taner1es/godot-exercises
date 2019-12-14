shader_type spatial;
render_mode specular_toon;

uniform sampler2D noise;
uniform float height_scale = 0.5;

varying vec2 vertex_position;

float wave(vec2 position, float power){
	position += texture(noise, position / 10.0).x * 2.0 - 1.0;
	vec2 wv = 1.0 - abs(sin(position));
	return pow(1.0 - pow(wv.x * wv.y, 0.65), power);
}

float height(vec2 position, float time) {
	// Issue created about here, https://github.com/godotengine/godot-docs/issues/2847

//	vec2 offset = 0.01 * cos(position + time);
//	return texture(noise, (position / 10.0) - offset).x;
//	float h = wave(position*0.4);

	float d = wave((position + time) * 0.4, 8.0) * 0.3;
	d += wave((position - time) * 0.3, 8.0) * 0.3;
	d += wave((position + time) * 0.5, 4.0) * 0.2;
	d += wave((position - time) * 0.6, 4.0) * 0.2;
	return d;
}

void vertex() {
	vec2 pos = VERTEX.xz;
	float k = height(pos, TIME);
	VERTEX.y = k;
	
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0), TIME), 0.1, k - height(pos + vec2(0.0, 0.1), TIME)));
}

void fragment(){
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));	
	
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel);
	
	RIM = 0.2;
}




