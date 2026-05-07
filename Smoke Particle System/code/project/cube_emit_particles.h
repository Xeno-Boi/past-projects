#ifndef CUBE_EMIT_PARTICLES_H_
#define CUBE_EMIT_PARTICLES_H_

#include "emit_particles.h"

class CubeEmitParticles : public EmitParticles {
public:
	CubeEmitParticles();
	~CubeEmitParticles();

	void createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) override;
};

#endif