#include "flame_emit_particles.h"
#include <iostream>

using namespace std;

FlameEmitParticles::FlameEmitParticles() {
	setNumParticles(450);

	setParticleColor(Vector4f(0.9f, 0.7f, 0.2f, 0.01f));

	setRollAngle(55, 125);
	setYawAngle(0, 360);

	setParticleScale(10.0f, 15.0f, 7.0f);

	setPhysics(-30.0f, 1.0f, LINEAR_ACCELERATION, 40.0f, 70.0f);

	renderInTriangles();
	renderWithColor();
}

FlameEmitParticles::~FlameEmitParticles() {

}

void FlameEmitParticles::createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) {
	const int vertex_attr = 9;	// number of attributes of each entry of vertex[]
	const int vertex_num = 8;	// number of vertices of each particle
	const int index_num = 36;	// number of indices

	GLfloat* vertex = new GLfloat[vertex_attr * vertex_num]{
		// Position				Color																		Texture coordinates
		-1.0f,  1.0f,  1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f,	// Top-left-front
		 1.0f,  1.0f,  1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Top-right-front
		-1.0f, -1.0f,  1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  1.0f,	// Bottom-left-front
		-1.0f,  1.0f, -1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Top-left-back
		 1.0f,  1.0f, -1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f,	// Top-right-back
		 1.0f, -1.0f, -1.0f,    particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Bottom-right-back
		-1.0f, -1.0f, -1.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  1.0f,	// Bottom-left-back
		 1.0f, -1.0f,  1.0f,    particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  1.0f,	// Bottom-right-front
	};

	GLuint* index = new GLuint[index_num]{
		// front
		0, 1, 2,
		2, 3, 0,
		// left
		4, 0, 3,
		3, 7, 4,
		// back
		5, 4, 7,
		5, 7, 6,
		// right
		1, 5, 6,
		1, 6, 2,
		// top
		4, 5, 1,
		4, 1, 0,
		// bottom
		3, 2, 6,
		3, 6, 7
	};

	*out_vertex = vertex;
	*out_index = index;
	*out_vertex_attr = vertex_attr;
	*out_vertex_num = vertex_num;
	*out_index_num = index_num;
}


