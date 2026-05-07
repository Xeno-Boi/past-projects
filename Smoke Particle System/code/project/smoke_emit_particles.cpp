#include "smoke_emit_particles.h"
#include <iostream>

using namespace std;

SmokeEmitParticles::SmokeEmitParticles() {
	setNumParticles(5000);

	setParticleColor(Vector4f(0.3f, 0.3f, 0.3f, 0.02f));

	setRollAngle(0, 360);
	setYawAngle(0, 360);

	setParticleScale(15.0f, 10.0f, 0.0f);

	// small area of smoke
	setPhysics(0.0f, 2.0f, OVAL_DECELERATION, 25.0f, 0.0f);

	// large area of smoke
	/*
	setModelScale(5, 5, 5);
	setPhysics(0.0f, 2.0f, OVAL_DECELERATION, 50.0f, 0.0f);
	*/

	renderInTriangles();
	renderWithColor();
}

SmokeEmitParticles::~SmokeEmitParticles() {

}

void SmokeEmitParticles::createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) {
	const int vertex_attr = 9;	// number of attributes of each entry of vertex[]
	const int vertex_num = 8;	// number of vertices of each particle
	const int index_num = 36;	// number of indices

	GLfloat* vertex = new GLfloat[vertex_attr * vertex_num]{
		// Position				Color																		Texture coordinates
		-1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f,	// Top-left-front
		 1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Top-right-front
		 1.0f, -1.0f,  0.0f,    particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  1.0f,	// Bottom-right-front
		-1.0f, -1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  1.0f,	// Bottom-left-front
	};

	GLuint* index = new GLuint[index_num]{
		// front
		0, 1, 2,
		2, 3, 0
	};

	*out_vertex = vertex;
	*out_index = index;
	*out_vertex_attr = vertex_attr;
	*out_vertex_num = vertex_num;
	*out_index_num = index_num;
}


