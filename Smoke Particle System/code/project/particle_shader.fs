#version 330

#define RENDER_COLOR 10
#define RENDER_TEXTURE 11

//structure of the fragment datga from the vertex shader
in vec4 colour;

out vec4 outColor;

uniform int texture_mode;

void main()

{
	if (texture_mode == RENDER_COLOR){
		// output the colour
		outColor = colour;
	} else if (texture_mode == RENDER_TEXTURE){
		discard;
	} else {
		// output the colour
		outColor = vec4(0.0, 0.0, 1.0, 1.0);
	}
}
