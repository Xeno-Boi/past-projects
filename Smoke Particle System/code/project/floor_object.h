#ifndef FLOOR_OBJECT_H_
#define FLOOR_OBJECT_H_

#include "graphicsObject.h"

// class for particles that gets emitted from a point and flies out

class FloorObject : public GraphicsObject {
public:
	FloorObject();
	~FloorObject();

	int createGeom(Shader shader);
	int createVAO(Shader shader, Vertices vtx, Indices ind);

	int render(Shader shader);

protected:
};

#endif