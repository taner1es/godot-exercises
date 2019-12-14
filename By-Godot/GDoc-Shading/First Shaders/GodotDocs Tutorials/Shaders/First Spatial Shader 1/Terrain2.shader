shader_type spatial;

uniform sampler2D noise;


void vertex() {
	float height = texture(noise, VERTEX.xz / 2.0).r;
	VERTEX.y += height;
}