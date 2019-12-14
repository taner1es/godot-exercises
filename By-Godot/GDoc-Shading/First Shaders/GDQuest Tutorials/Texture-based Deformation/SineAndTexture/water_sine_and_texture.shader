shader_type canvas_item;

uniform float tile_factor = 10.0;
uniform float aspect_ratio = 0.5;

uniform sampler2D uv_offset_texture : hint_black;
uniform vec2 uv_offset_size = vec2(1.0, 1.0);
uniform vec2 uv_offset_wave_size = vec2(0.1, 0.1);

uniform float time_scale = 0.05;

uniform float sine_time_factor = 2.0;
uniform vec2 sine_offset_factor = vec2(5.0, 2.0);
uniform vec2 sine_wave_size = vec2(0.05, 0.05);

vec2 calculate_waves_offset(float time, float multiplier, vec2 uv, vec2 scale){
	vec2 offset;
	float time_multiplied = time * multiplier;
	float unique_offset = uv.x + uv.y;
	offset.x += sin(time_multiplied + unique_offset * scale.x);
	offset.y += cos(time_multiplied + unique_offset * scale.y);
	return offset;
}

void fragment() {
	vec2 tiled_uvs = UV * tile_factor;
	tiled_uvs.y *= aspect_ratio;
	
	vec2 offset_texture_uvs = UV * uv_offset_size;
	offset_texture_uvs += TIME * time_scale;
	
	vec2 texture_based_offset = texture(uv_offset_texture, offset_texture_uvs).rg;
	texture_based_offset = texture_based_offset * 2.0 - 1.0;
	texture_based_offset *= uv_offset_wave_size;
	
	vec2 wave_uv_offset = calculate_waves_offset(TIME, sine_time_factor, tiled_uvs, sine_offset_factor);
	
	COLOR = texture(TEXTURE, tiled_uvs + wave_uv_offset * sine_wave_size + texture_based_offset);
}