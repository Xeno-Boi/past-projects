#ifndef SMOKE_EMIT_PARTICLES_H_
#define SMOKE_EMIT_PARTICLES_H_

#include "emit_particles.h"

class SmokeEmitParticles : public EmitParticles {
public:
	SmokeEmitParticles();
	~SmokeEmitParticles();

	void createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) override;
};

#endif