shader_type spatial;

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
	NORMALMAP = texture(normalmap, vertex_position).xyz;
}
