#version 330

//structure of the fragment datga from the vertex shader
//in vec4 color;
in vec4 pos;

out vec4 outColor;

uniform int texture_mode;

void main()

{
	// output the colour
	//outColor = colour;
	// set color
	if (mod(pos.x, 200) < 100){
		if (mod(pos.z, 200) < 100){
			outColor = vec4(0.2, 0.2, 0.2, 1.0);
		} else {
			outColor = vec4(0.1, 0.1, 0.1, 1.0);
		}
	} else {
		if (mod(pos.z, 200) < 100){
			outColor = vec4(0.1, 0.1, 0.1, 1.0);
		} else {
			outColor = vec4(0.2, 0.2, 0.2, 1.0);
		}
	}
	//outColor = vec4(1.0, 1.0, 1.0, 1.0);
}
