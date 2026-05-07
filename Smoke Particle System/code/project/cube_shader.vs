#version 330 core

uniform mat4 model; 
uniform mat4 view; 
uniform mat4 projection;
uniform mat4 world;

in vec4 vtxPos;
in vec4 vtxCol;

// strcutre to be passed to the fragment shader
out vec4 color;	// vertex colour


	

void main()

{
	vec4 pos = vtxPos; // Vertex position

	// transform the vertex position
	pos = world * model * pos;

	gl_Position = projection * view * pos;	// vertex transformation

	color = vtxCol;
	//color = vec4(0.2, 0.2, 0.2, 1.0);
}


