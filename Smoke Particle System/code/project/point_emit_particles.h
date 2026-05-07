#ifndef POINT_EMIT_PARTICLES_H_
#define POINT_EMIT_PARTICLES_H_

#include "emit_particles.h"

class PointEmitParticles : public EmitParticles {
public:
	PointEmitParticles();
	~PointEmitParticles();

	void createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) override;
};

#endif