#include "cube_object.h"
#include <iostream>

using namespace std;

CubeObject::CubeObject() {

}

CubeObject::~CubeObject() {

}

int CubeObject::createGeom(Shader shader) {
	Vertices vtx;
	Indices ind;

	const int vertex_attr = 7;	// number of attributes of each entry of vertex[]

	GLfloat vertex[] = {
	// Position				Color
	 -1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f, 1.0f,		// Top-left-front
	  1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f, 1.0f,		// Top-right-front
	  1.0f, -1.0f,  1.0f,   1.0f, 0.0f, 0.0f, 1.0f,		// Bottom-right-front
	 -1.0f, -1.0f,  1.0f,	0.0f, 0.0f, 1.0f, 1.0f,		// Bottom-left-front
	 -1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f, 1.0f,		// Top-left-back
	  1.0f,  1.0f, -1.0f,	1.0f, 0.0f, 0.0f, 1.0f,		// Top-right-back
	  1.0f, -1.0f, -1.0f,   0.0f, 0.0f, 1.0f, 1.0f,		// Bottom-right-back
	 -1.0f, -1.0f, -1.0f,	1.0f, 0.0f, 0.0f, 1.0f		// Bottom-left-back
	};

	GLuint index[] = {
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

	for (int i = 0; i < 36; i++) {
		ind.push_back(index[i]);
	}

	for (int i = 0; i < 8; i++) {
		// Set position
		Vector4f pos = Vector4f(vertex[i * vertex_attr + 0], vertex[i * vertex_attr + 1], vertex[i * vertex_attr + 2], 1.0f);

		// Set Color
		Vector4f col = Vector4f(vertex[i * vertex_attr + 3], vertex[i * vertex_attr + 4], vertex[i * vertex_attr + 5], vertex[i * vertex_attr + 6]);
		
		vtx.push_back(Vertex(pos, col));
	}

	// create vao
	int rc = createVAO(shader, vtx, ind);
	return rc;
}


int CubeObject::createVAO(Shader shader, Vertices vtx, Indices ind) {

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
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * vtx.size(), (void*)vtx.data(), GL_STATIC_DRAW);

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
	glVertexAttribPointer(vtxPosLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, pos));

	//set the vertex color - repeat for vertex colour 
	GLuint vtxColLoc = glGetAttribLocation(shaderProgId, "vtxCol");

	if (vtxColLoc == -1) {
		rc = -1;
		goto err;
	}

	glEnableVertexAttribArray(vtxColLoc);

	glVertexAttribPointer(vtxColLoc, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, col));

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


int CubeObject::render(Shader shader)
{
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

	// bind the vao
	glBindVertexArray(vao);

	// bine index buffer
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indVBO);

	// render
	glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, NULL);
	//glPointSize(10);
	//glDrawArrays(GL_POINTS, 0, 4);

	// unbind the vao
	//glBindVertexArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

	return 0;
}