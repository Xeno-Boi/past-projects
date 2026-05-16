shader_type canvas_item;

// properties
uniform float speed = 7.0;
uniform float intensity = 1.5;
uniform bool shaking = false;

// helpers 
float triangle_wave(float x) {
	return intensity * (abs(fract(x) - 0.5) - 0.3);
}

void vertex() {
	// Called for every vertex the material is visible on.
	if (shaking) {
		float time_scaled = TIME * speed;
		float x_offset = triangle_wave(time_scaled);
		
		VERTEX.x += x_offset;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
