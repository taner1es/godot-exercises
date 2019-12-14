shader_type canvas_item;
// background has an alpha of 0 (as it does in this case) 
// [we did set the viewport "transparent background" property]
// you end up with weird color bleed issues. 
// Setting blend_premul_alpha fixes that.
render_mode blend_premul_alpha;

vec3 hash(vec3 p) {
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
             dot(p, vec3(269.5, 183.3, 246.1)),
             dot(p, vec3(113.5, 271.9, 124.6)));

    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  vec3 u = f * f * (3.0 - 2.0 * f);

  return mix(mix(mix(dot(hash(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
                     dot(hash(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
                     dot(hash(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
             mix(mix(dot(hash(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                     dot(hash(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                     dot(hash(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z );
}

void fragment() {
	
	// Makes gradient
	// -------
//	COLOR = vec4(UV.x, UV.y, 0.5, 1.0);
	// -------
	
	// Solution 1 to wrap around the sphere
	// using "sin" and "cos" functions
	// -------
//	COLOR.xyz = vec3(sin(UV.x * 3.14159 * 4.0) * cos(UV.y * 3.14159 * 4.0) * 0.5 + 0.5);
	// -------
	
	// Solution 2 to wrap around the sphere
	// converting from spherical coordinates into Cartesian coordinates
	// -------
	float theta = UV.y * 3.14159;
	float phi = UV.x * 3.14159 * 2.0;
	vec3 unit = vec3(0.0, 0.0, 0.0);
	
	unit.x = sin(phi) * sin(theta);
	unit.y = cos(theta) * -1.0;
	unit.z = cos(phi) * sin(theta);
	unit = normalize(unit);	
//	COLOR.xyz = unit;
	// -------
	
	
	//Now that we can calculate the 3D position of the surface of 
	//the sphere, we can use 3D noise to make the planet. 
	//We will be using this noise function directly from a Shadertoy:
	// -------
//	float n = noise(unit * 5.0);
//	COLOR.xyz = vec3(n*0.5 +0.5);
	// -------
	
	// Coloring with mix function, references:
	// vec_type mix ( float a, float b, float c ) 	Linear Interpolate
	// vec_type mix ( vec_type a, vec_type b, float c ) 	Linear Interpolate (Scalar Coef.)
	// vec_type mix ( vec_type a, vec_type b, vec_type c ) 	Linear Interpolate (Vector Coef.)
	// vec_type mix ( vec_type a, vec_type b, bvec_type c ) 	Linear Interpolate (Boolean-Vector Selection)
	// -------
//	COLOR.xyz = mix(vec3(0.05, 0.3, 0.5), vec3(0.9, 0.4, 0.1), n * 0.5 + 0.5);
	// -------
	
	// Blurring with smoothstep function, references:
	//vec_type smoothstep ( vec_type a, vec_type b, vec_type c ) 	Hermite Interpolate
	//vec_type smoothstep ( float a, float b, vec_type c ) 	Hermite Interpolate
	// -------
//	float n = noise(unit * 5.0);
//	COLOR.xyz = mix(vec3(0.05, 0.3, 0.5), vec3(0.9, 0.4, 0.1), smoothstep(-0.1, 0.0, n));
	// -------
	
	// make the edges a little rougher.
	// We use one layer to make the overall blobby structure of the continents. 
	// Then another layer breaks up the edges a bit, and then another, and so on.
	// -------
	float n = noise(unit * 5.0) * 0.5;
	n += noise(unit * 10.0) * 0.25;
	n += noise(unit * 20.0) * 0.125;
	n += noise(unit * 40.0) * 0.0625;
	COLOR.xyz = mix(vec3(0.05, 0.3, 0.5), vec3(0.9, 0.4, 0.1), smoothstep(-0.1, 0.0, n));
	
	// we want the ocean to shine a little more than the land. 
	// We can do this by passing a fourth value into the alpha channel of our output COLOR and using it as a Roughness map.
	COLOR.a = 0.3 + 0.7 * smoothstep(-0.1, 0.0, n);
	// -------
}