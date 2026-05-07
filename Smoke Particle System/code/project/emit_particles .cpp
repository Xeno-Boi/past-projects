#include "emit_particles.h"
#include <iostream>

using namespace std;

EmitParticles::EmitParticles() {

}

EmitParticles::~EmitParticles() {

}


void EmitParticles::createArrays(GLfloat** out_vertex, GLuint** out_index, int* out_vertex_attr, int* out_vertex_num, int* out_index_num) {
	const int vertex_attr = 9;	// number of attributes of each entry of vertex[]
	const int vertex_num = 4;	// number of vertices of each particle
	const int index_num = 6;	// number of indices

	GLfloat* vertex = new GLfloat[vertex_attr * vertex_num]{
	// Position				Color																		Texture coordinates
	-1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  0.0f,	// Top-left
	 1.0f,  1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  0.0f,	// Top-right
	 1.0f, -1.0f,  0.0f,    particle_color.x, particle_color.y, particle_color.z, particle_color.w,		1.0f,  1.0f,	// Bottom-right
	-1.0f, -1.0f,  0.0f,	particle_color.x, particle_color.y, particle_color.z, particle_color.w,		0.0f,  1.0f		// Bottom-left
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


int EmitParticles::createGeom(Shader shader) {
	ParticleVertices vtx;
	Indices ind;
	
	int vertex_attr;	// number of attributes of each entry of vertex[]
	int vertex_num;		// number of vertices of each particle
	int index_num;		// number of indices
	GLfloat* vertex;
	GLuint* index;

	createArrays(&vertex, &index, &vertex_attr, &vertex_num, &index_num);

	float roll_angle, yaw_angle, pitch_angle, r, phraseMod;

	float roll_interval = max_roll_angle - min_roll_angle;
	float yaw_interval = max_yaw_angle - min_yaw_angle;

	// Set self scale
	Matrix4f scaleMat = Matrix4f::scale(particle_scale_x, particle_scale_y, particle_scale_z);

	// Initialize all particle vertices
	for (int i = 0; i < num_particles; i++) {
		// set up index vector
		for (int j = 0; j < index_num; j++) {
			ind.push_back(i * vertex_num + index[j]);
		}
		
		// get 4 randomized values
		// angles in degrees
		roll_angle = (roll_interval * (rand() % 1000) / 1000.0f) + min_roll_angle;		// roll (angle of rotation around z axis)
		yaw_angle = (yaw_interval * (rand() % 1000) / 1000.0f) + min_yaw_angle;		// yaw (angle of rotation around y axis)
		r = 1.0f;		// radius modifier
		phraseMod = (rand() % 10000) / 10000.0f;	// randomize phrase of particles

		// Set direction
		Vector4f vec = Vector4f(1.0f, 0.0f, 0.0f, 0.0f);
		Matrix4f rotMat;
		rotMat = Matrix4f::rotateXYZ(roll_angle, 0.0f, yaw_angle, 1);
		vec = rotMat * vec;
		Vector3f dir = Vector3f(vec.x, vec.y, vec.z);

		// Set self rotation
		// Get 2 randomized angles
		roll_angle = (360 * (rand() % 1000) / 1000.0f);		// roll (angle of rotation around z axis)
		yaw_angle = (360 * (rand() % 1000) / 1000.0f);		// yaw (angle of rotation around y axis)
		pitch_angle = (360 * (rand() % 1000) / 1000.0f);	// pitch (angle of rotation around x axis
		// Set up matrix
		rotMat = Matrix4f::rotateXYZ(roll_angle, pitch_angle, yaw_angle, 1);

		// Set Transformation Matrix
		Matrix4f transMat = rotMat * scaleMat;

		// set up vtx vector
		for (int j = 0; j < vertex_num; j++) {
			int current = j * vertex_attr;

			// Set position
			Vector4f pos = Vector4f(vertex[current], vertex[current + 1], vertex[current + 2], 1.0f);
			pos = transMat * pos;

			// Set Color
			Vector4f col = Vector4f(vertex[current + 3], vertex[current + 4], vertex[current + 5], vertex[current + 6]);
		
			// Push to vtx
			vtx.push_back(ParticleVertex(pos, dir, col, phraseMod));
		}
	}

	delete[] vertex;
	delete[] index;

	// create vao
	int rc = createVAO(shader, vtx, ind);
	return rc;
}


int EmitParticles::createVAO(Shader shader, ParticleVertices vtx, Indices ind) {

	int rc = 0;

	GLint location = 0;		// location of the attributes in the shader;

	int shaderProgId = shader.getProgId();

	//create vertex array object 
	// get an object (VAO)
	glGenVertexArrays(1, &vao);

	// bind the vertex array
	glBindVertexArray(vao);

	//create vertex buffer object
	// get an object (VBO)
	glGenBuffers(1, &vtxVBO);

	// bind the buffer object
	glBindBuffer(GL_ARRAY_BUFFER, vtxVBO);

	//transfer the data
	glBufferData(GL_ARRAY_BUFFER, sizeof(ParticleVertex) * vtx.size(), (void*)vtx.data(), GL_STATIC_DRAW);

	//set the vertex position information
	// get the location for the vertex position - match with the shader

	GLuint vtxPosLoc = glGetAttribLocation(shaderProgId, "vtxPos");

	if (vtxPosLoc == -1) {
		rc = -1;
		goto err;
	}

	// enable the location
	glEnableVertexAttribArray(vtxPosLoc);

	// inform opengl about the attribute address
	glVertexAttribPointer(vtxPosLoc, 4, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex), (void*)offsetof(ParticleVertex, pos));

	//set the vertex color - repeat for vertex colour 
	GLuint vtxColLoc = glGetAttribLocation(shaderProgId, "vtxCol");

	if (vtxColLoc == -1) {
		rc = -1;
		goto err;
	}

	glEnableVertexAttribArray(vtxColLoc);

	glVertexAttribPointer(vtxColLoc, 4, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex), (void*)offsetof(ParticleVertex, col));



	//set the vertex direction

	GLuint vtxDirectionLoc = glGetAttribLocation(shaderProgId, "vtxDirection");

	if (vtxDirectionLoc == -1) {
		rc = -1;
		goto err;
	}

	glEnableVertexAttribArray(vtxDirectionLoc);

	glVertexAttribPointer(vtxDirectionLoc, 3, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex), (void*)offsetof(ParticleVertex, direction));


	// set the vertex phrase

	GLuint vtxPhraseLoc = glGetAttribLocation(shaderProgId, "vtxPhrase");

	if (vtxPhraseLoc == -1) {
		rc = -1;
		goto err;
	}

	glEnableVertexAttribArray(vtxPhraseLoc);

	glVertexAttribPointer(vtxPhraseLoc, 1, GL_FLOAT, GL_FALSE, sizeof(ParticleVertex), (void*)offsetof(ParticleVertex, phrase));




	//end creation unbind the vertex array buffer
	glBindVertexArray(0);

	//create index buffer
	// get a handle
	glGenBuffers(1, &indVBO);

	// bind the buffer
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indVBO);

	// transfer the data
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(int) * ind.size(), (void*)ind.data(), GL_STATIC_DRAW);

	// store the number of indices
	numIndices = ind.size();

	// release the buffer 
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);


	return(0);
err:
	return(rc);
}


int EmitParticles::render(Shader shader)
{
	glDepthMask(GL_FALSE);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE);

	Matrix4f rotMat;  // rotation matrix;
	Matrix4f scaleMat; // scaling matrix;
	Matrix4f transMat;	// translation matrix
	Matrix4f modelMat;	// final model matrix

	Matrix4f worldMat;	// final world matrix

	int shaderProgId = shader.getProgId();

	// model

	// set the transformation matrix - the model transfomration
	modelMat = Matrix4f::identity(); // = Matrix4f::rotateRollPitchYaw(rollAngle, pitchAngle, yawAngle, 1);

	// set the scaling - this is model space to model space transformation
	scaleMat = Matrix4f::scale(scale.x, scale.y, scale.z);
	modelMat = scaleMat * modelMat;

	// set the rotation  - this is model space to model space transformation 
	rotMat = Matrix4f::rotateRollPitchYaw(rollAngle, pitchAngle, yawAngle, 1);
	//rotMat = Matrix4f::identity();
	// note that we always multiply the new matrix on the left
	modelMat = rotMat * modelMat;


	// set the translation - this is model space to world space transformation
	transMat = Matrix4f::translation(position);
	modelMat = transMat * modelMat;

	// move matrix to shader
	shader.copyMatrixToShader(modelMat, "model");


	// world

	// set the transformation matrix - the model transfomration
	worldMat = Matrix4f::identity(); // = Matrix4f::rotateRollPitchYaw(rollAngle, pitchAngle, yawAngle, 1);

	// set the scaling - this is model space to model space transformation
	scaleMat = Matrix4f::scale(worldScale.x, worldScale.y, worldScale.z);
	worldMat = scaleMat * worldMat;

	// set the rotation  - this is model space to model space transformation 
	rotMat = Matrix4f::rotateRollPitchYaw(worldRollAngle, worldPitchAngle, worldYawAngle, 1);
	//rotMat = Matrix4f::identity();
	// note that we always multiply the new matrix on the left
	worldMat = rotMat * worldMat;


	// set the translation - this is model space to world space transformation
	transMat = Matrix4f::translation(worldPosition);
	worldMat = transMat * worldMat;

	// move matrix to shader
	shader.copyMatrixToShader(worldMat, "world");

	// uniforms
	int location = -1;

	// transfer gravity to the shader program
	location = glGetUniformLocation(shaderProgId, "gravity");

	glUniform1f(location, gravity);

	// transfer acceleration type to the shader program
	location = glGetUniformLocation(shaderProgId, "acceleration_type");

	glUniform1i(location, acceleration_type);

	// transfer initial speed to the shader program
	location = glGetUniformLocation(shaderProgId, "initial_speed");

	glUniform1f(location, initial_speed);

	// transfer final speed to the shader program
	location = glGetUniformLocation(shaderProgId, "final_speed");

	glUniform1f(location, final_speed);

	// transfer cycle to the shader program
	location = glGetUniformLocation(shaderProgId, "cycle");

	glUniform1f(location, cycle);

	// transfer texture mode to the shader program
	location = glGetUniformLocation(shaderProgId, "texture_mode");

	glUniform1i(location, texture_mode);

	// transfer current time to the shader program
	location = glGetUniformLocation(shaderProgId, "time");

	glUniform1f(location, current_time);

	// bind the vao
	glBindVertexArray(vao);

	// bine index buffer
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indVBO);

	// render
	switch (render_mode) {
	case RENDER_POINTS:
		glPointSize(point_particle_scale);
		glDrawElements(GL_POINTS, numIndices, GL_UNSIGNED_INT, NULL);
		break;

	case RENDER_TRIANGLES:
		glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, NULL);
	}
	//glDrawArrays(GL_POINTS, 0, num_particles);

	// unbind the vao
	//glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

	glDepthMask(GL_TRUE);
	glDisable(GL_BLEND);

	return 0;
}


void EmitParticles::setParticleScale(float scale_x, float scale_y, float scale_z) {
	particle_scale_x = scale_x;
	particle_scale_y = scale_y;
	particle_scale_z = scale_z;
}


void EmitParticles::setRollAngle(float min_angle, float max_angle) {
	min_roll_angle = min_angle;
	max_roll_angle = max_angle;
}


void EmitParticles::setYawAngle(float min_angle, float max_angle) {
	min_yaw_angle = min_angle;
	max_yaw_angle = max_angle;
}


void EmitParticles::setPhysics(float gravity, float cycle, int acceleration_type, float initial_speed, float final_speed) {
	this->gravity = gravity;
	this->acceleration_type = acceleration_type;
	this->initial_speed = initial_speed;
	this->final_speed = final_speed;
	this->cycle = cycle;
}