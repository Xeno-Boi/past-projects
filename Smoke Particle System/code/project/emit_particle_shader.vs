#version 330 core

#define LINEAR_ACCELERATION 10
#define OVAL_DECELERATION 11

uniform mat4 model; 
uniform mat4 view; 
uniform mat4 projection;
uniform mat4 world;
uniform float time;
uniform float gravity;
uniform float initial_speed;
uniform float final_speed;
uniform float cycle;
uniform int acceleration_type;

in vec4 vtxPos;
in vec4 vtxCol;
in vec3 vtxDirection;
in float vtxPhrase;

// strcutre to be passed to the fragment shader
out vec4 colour;	// vertex colour


	

void main()

{
	float pi = radians(180.0);
	vec4 pos;	// Vertex position
	float acttime;	// Cyclic time
	float acceleration;
	float displacement;

	// move particle
	acttime = mod(time + vtxPhrase * cycle, cycle);		// recycling particles
	//acttime = time + vtxPhrase * cycle;					// not recycling particles

	switch(acceleration_type){
		case LINEAR_ACCELERATION:
			// find acceleration
			acceleration = (final_speed - initial_speed) / cycle;

			// find displacement
			displacement = (initial_speed * acttime) + (0.5 * acceleration * acttime * acttime);
			break;

		case OVAL_DECELERATION:
			// find displacement
			displacement = initial_speed * ( pow( cycle, 2 ) * asin( acttime / cycle ) + acttime * sqrt( pow( cycle, 2 ) - pow( acttime, 2 ) ) ) / ( 2 * cycle );
			break;

		default:
			displacement = 0;
	}

	// move particle along direction
	pos = vtxPos + (vec4(vtxDirection, 0) * displacement);

	// transform the vertex position
	pos = world * model * pos;

	// add gravity effect
	pos = vec4(pos.x, pos.y - (0.5 * gravity * acttime * acttime), pos.z, pos.w);

	gl_Position = projection * view * pos;	// vertex transformation

	// set color
	colour = vtxCol;
}


