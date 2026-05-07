shader_type spatial;
render_mode cull_disabled;

uniform vec4 color : source_color = vec4(0.3, 0.2, 1.0, 0.5);
uniform float fade_out_distance = 1.0;
uniform float base_y = 0.0;

varying float output_alpha;

void vertex() {
	// Called for every vertex the material is visible on.
	// set fade out based on base_y
	float fade_multiplier = fade_out_distance - (VERTEX.y - base_y);
	output_alpha = clamp(color.a * fade_multiplier, 0.0, color.a);
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = color.rgb;
	// remove top and bottom face
	vec3 world_normal = (INV_VIEW_MATRIX * vec4(NORMAL.xyz, 0.0)).xyz;
	if (abs(world_normal.y) > 0.9) {
		discard;
	}
	ALPHA = output_alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
