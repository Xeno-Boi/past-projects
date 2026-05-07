#include "point_emit_particles.h"
#include <iostream>

using namespace std;

PointEmitParticles::PointEmitParticles() {
	setNumParticles(1000);

	setParticleColor(Vector4f(0.5f, 0.1f, 0.01f, 1.0f));

	setRollAngle(25, 155);
	setYawAngle(0, 360);

	setParticleScale(5.0f);

	setPhysics(1.5f, 10.0f, LINEAR_ACCELERATION, 10.0f, 10.0f);

	renderInPoints();
	renderWithColor();
}

PointEmitParticles::~PointEmitParticles() {

}

void PointEmitParticles::createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) {
	const int vertex_attr = 9;	// number of attributes of each entry of vertex[]
	const int vertex_num = 1;	// number of vertices of each particle
	const int index_num = 1;	// number of indices

	GLfloat* vertex = new GLfloat[vertex_attr * vertex_num]{
		// Position				Color																		Texture coordinates
		 0.0f,  0.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f
	};

	GLuint* index = new GLuint[index_num]{
		0
	};

	*out_vertex = vertex;
	*out_index = index;
	*out_vertex_attr = vertex_attr;
	*out_vertex_num = vertex_num;
	*out_index_num = index_num;
}


