shader_type canvas_item;

uniform bool highlight;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a <= 0.0){
		discard;
	}
	vec4 highlight_color = vec4(1.0, 1.0, 1.0, 1.0);
	COLOR = mix(texture_color, highlight_color, float(highlight) * 0.5);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
