#version 330

//structure of the fragment datga from the vertex shader
in vec4 color;

out vec4 outColor;

//uniform int texture_mode;

void main()

{
	// output the color
	outColor = color;
	//outColor = vec4(1.0, 1.0, 1.0, 1.0);
}
