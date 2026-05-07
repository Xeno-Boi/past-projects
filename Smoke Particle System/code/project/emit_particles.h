#ifndef EMIT_PARTICLES_H_
#define EMIT_PARTICLES_H_

#include "graphicsObject.h"

struct ParticleVertex {
	ParticleVertex(const Vector4f _pos, const Vector3f _direction, const Vector4f _col, const float _phrase) {
		pos = _pos;
		col = _col;
		direction = _direction;
		phrase = _phrase;
	}

	Vector4f pos;
	Vector3f direction;
	Vector4f col;
	Vector2f uv;
	float phrase;
};

typedef struct ParticleVertex ParticleVertex;

typedef std::vector<ParticleVertex> ParticleVertices;


// class for particles that gets emitted from a point and flies out

class EmitParticles : public GraphicsObject {
public:
	EmitParticles();
	~EmitParticles();

	// override this function to create new vertices and indices
	virtual void createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num);
	
	int createGeom(Shader shader);
	int createVAO(Shader shader, ParticleVertices vtx, Indices ind);

	inline void update(float delta_time) { current_time += delta_time; };
	int render(Shader shader);

	// setters
	inline void renderInPoints() { render_mode = RENDER_POINTS; };
	inline void renderInTriangles() { render_mode = RENDER_TRIANGLES; };

	inline void renderWithColor() { texture_mode = RENDER_COLOR; };
	inline void renderWithTexture() { texture_mode = RENDER_TEXTURE; };

	// the below functions should be set before CreateGeom

	inline void setNumParticles(int num) { num_particles = num; };

	inline void setParticleColor(Vector4f color) { particle_color = color; };

	// for triangle particles
	void setParticleScale(float scale_x, float scale_y, float scale_z);
	// for point particles
	inline void setParticleScale(float point_scale) { point_particle_scale = point_scale; };

	void setRollAngle(float min_angle, float max_angle);
	void setYawAngle(float min_angle, float max_angle);

	// set all physics attributes
	// acceleration type:
	//	LINEAR_ACCELERATION - accelerates particle linearly from initial_speed to final_speed
	//	OVAL_DECELERATION - decelerates particle with an oval equation (faster at start, slower at end)
	void setPhysics(float gravity, float cycle, int acceleration_type, float initial_speed, float final_speed = 0.0f);

protected:
	int render_mode = RENDER_TRIANGLES;
	int texture_mode = RENDER_COLOR;

	int num_particles = 1000;	// number of particles

	Vector4f particle_color = Vector4f(0.5f, 0.1f, 0.01f, 1.0f);

	// size of each particle
	float particle_scale_x = 1.0f;
	float particle_scale_y = 1.0f;
	float particle_scale_z = 1.0f;

	float point_particle_scale = 5.0f;

	// movement direction
	float min_roll_angle = 0;
	float max_roll_angle = 360;
	float min_yaw_angle = 0;
	float max_yaw_angle = 360;

	// physics properties
	float gravity = 0.0f;
	int acceleration_type = LINEAR_ACCELERATION;
	float initial_speed = 5.0f;
	float final_speed = 0.0f;
	float cycle = 10.0;		// Duration of cycle (lifespan of particles) in seconds

	float current_time = 0.0f;
};

#endif