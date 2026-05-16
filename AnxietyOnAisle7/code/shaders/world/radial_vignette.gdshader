shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// properties
uniform int anxiety = 0;
uniform int max_anxiety = 1000;
// radial
uniform float radial_min_start_value = -1.0;
uniform float radial_min_end_value = 0.5;
// oscillation
uniform float oscillation_speed = 0.7;
uniform float oscillation_amplitude = 0.05;
uniform float oscillation_offset = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	// oscillation
	float oscillation = sin(TIME * oscillation_speed) * oscillation_amplitude + oscillation_offset;
	// radial
	vec2 screen_center = vec2(0.5, 0.5);
	float start_value = clamp(mix(1.0, radial_min_start_value, float(anxiety) / float(max_anxiety)) + oscillation, -100.0, 1.0);
	float end_value = clamp(mix(1.0, radial_min_end_value, float(anxiety) / float(max_anxiety)) + oscillation, -100.0, 1.0);
	float distance_from_center = distance(SCREEN_UV, screen_center);
	float darken = smoothstep(start_value, end_value, distance_from_center); 
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec3 no_alpha = screen_color.xyz * (1.0 - darken);
	COLOR = vec4(no_alpha, screen_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
