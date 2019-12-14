shader_type spatial;

uniform float time_scale;
uniform float side_to_side;
uniform float pivot;
uniform float wave;
uniform float twist;

uniform float mask_black : hint_range(0,1);
uniform float mask_white : hint_range(0,1);

varying vec3 instance_custom;


void vertex(){
	
	
	//time_scale is a uniform float
	//set speed from 50% - 150% of regular speed
	float time = (TIME * (0.5 + INSTANCE_CUSTOM.y) * time_scale) + (6.28318 * INSTANCE_CUSTOM.x);
	instance_custom = cos(time * vec3(INSTANCE_CUSTOM.x, INSTANCE_CUSTOM.y, INSTANCE_CUSTOM.z)); 
	
	//side_to_side is a uniform float
	VERTEX.x += cos(time) * side_to_side;
	
	//angle is scaled by 0.1 so that the fish only pivots and doesn't rotate all the way around
	//pivot is a uniform float
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	//body is a float that is 0 at the tail of the fish and 1 at its head.
	float body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2
	
	//wave is a uniform float
	VERTEX.x += cos(time + body) * wave;
	
	
	//twist is a uniform float
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	
	VERTEX.xy = twist_matrix * VERTEX.xy;
	
	//mask_black and mask_white are uniforms
	float mask = smoothstep(mask_black, mask_white, 1.0 - body);
	
	//wave motion with mask
	VERTEX.x += cos(time + body) * mask * wave;
	
	//twist motion with mask
	VERTEX.xy = mix(VERTEX.xy, twist_matrix * VERTEX.xy, mask);
	
	
}

void fragment() {
	float alb_x = clamp(1.0 / instance_custom.x, 0.3, 0.8);
	float alb_y = clamp(1.0 / instance_custom.y, 0.3, 0.8);
	float alb_z = clamp(1.0 / instance_custom.z, 0.3, 0.8);
    
	//ALBEDO = vec3(alb_x, alb_y, alb_z); // use red for material albedo
}