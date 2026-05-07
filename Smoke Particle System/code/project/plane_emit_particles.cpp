#include "plane_emit_particles.h"
#include <iostream>

using namespace std;

PlaneEmitParticles::PlaneEmitParticles() {
	setNumParticles(1000);

	setParticleColor(Vector4f(0.5f, 0.1f, 0.01f, 1.0f));

	setRollAngle(25, 155);
	setYawAngle(0, 360);

	setParticleScale(1.0f, 1.0f, 1.0f);

	setPhysics(1.5f, 10.0f, LINEAR_ACCELERATION, 10.0f, 10.0f);

	renderInTriangles();
	renderWithColor();
}

PlaneEmitParticles::~PlaneEmitParticles() {

}

void PlaneEmitParticles::createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) {
	const int vertex_attr = 9;	// number of attributes of each entry of vertex[]
	const int vertex_num = 4;	// number of vertices of each particle
	const int index_num = 6;	// number of indices

	GLfloat* vertex = new GLfloat[vertex_attr * vertex_num]{
		// Position				Color																		Texture coordinates
		-1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f,	// Top-left
		 1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Top-right
		 1.0f, -1.0f,  0.0f,    particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  1.0f,	// Bottom-right
		-1.0f, -1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  1.0f	// Bottom-left
	};

	GLuint* index = new GLuint[index_num]{
		0, 1, 2,	// t1
		2, 3, 0		// t2
	};

	*out_vertex = vertex;
	*out_index = index;
	*out_vertex_attr = vertex_attr;
	*out_vertex_num = vertex_num;
	*out_index_num = index_num;
}


