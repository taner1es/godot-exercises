shader_type spatial;

uniform sampler2D noise;


void vertex() {
	VERTEX.y += cos(VERTEX.x * 4.0) * sin(VERTEX.z * 4.0);
}