shader_type spatial;
render_mode specular_toon;

uniform sampler2D noise;
uniform float height_scale = 0.5;
uniform sampler2D normalmap;

varying vec2 vertex_position;

void vertex() {
	float height = texture(noise, VERTEX.xz / 2.0).r;
	VERTEX.y += height * height_scale;
	vertex_position = VERTEX.xz / 2.0;
}

void fragment(){
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	
	NORMALMAP = texture(normalmap, vertex_position).xyz;
	
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.01, 0.03, 0.05) + (0.1 * fresnel);
	
	RIM = 0.2;
}




