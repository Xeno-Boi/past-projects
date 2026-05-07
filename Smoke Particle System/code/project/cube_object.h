#ifndef CUBE_OBJECT_H_
#define CUBE_OBJECT_H_

#include "graphicsObject.h"

// class for particles that gets emitted from a point and flies out

class CubeObject : public GraphicsObject {
public:
	CubeObject();
	~CubeObject();

	int createGeom(Shader shader);
	int createVAO(Shader shader, Vertices vtx, Indices ind);

	int render(Shader shader);

protected:
};

#endif