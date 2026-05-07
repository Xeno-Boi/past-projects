

//=============================================================================
// solution.c
//
//Author: Doron Nussbaum (C) 2023 All Rights Reserved.
//-----------------------------------------------------
//
// Purpose: 
//--------------
// a. solution framework for assignments
//
//
// Description:
//--------------
// A simple framework for drawing objecs 
//
//
// License
//--------------
//
// Code can be used for instructional and educational purposes.
// Usage of code for other purposes is not allowed without a given permission by the author.
//
//
// Disclaimer
//--------------
//
// The code is provided as is without any warranty

//=============================================================================

// INCLUDES

#include "Solution.h"


/************************************************************/
//	GLOBALS

Solution *Solution::sol = NULL;


/****************************************************************************/

Solution::Solution()
{}

/*************************************************************************/


Solution::~Solution()
{
	printf("\n exiting the progam gracefully\n");

}

/******************************************************************************/


// initializing the opengl functions and windows
int Solution::initOpenGL(int argc, char **argv, int posX, int posY, int winWidth, int winHeight)
{
	int winid1;
	//initialize glut
	glutInit(&argc, argv);

	//initialize OpenGLwindow
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
	glutInitWindowPosition(posX, posY);
	glutInitWindowSize(winWidth, winHeight);
	winid1 = glutCreateWindow("Drawing Basic Objects");
	checkGLError();

	//glutSetWindow(winid1);
	glClearColor(1.0, 1.0, 1.0, 1.0);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
	glEnable(GL_CULL_FACE);
	glFrontFace(GL_CW);
	glCullFace(GL_BACK);
	//glDisable(GL_CULL_FACE);
	glutDisplayFunc(Solution::renderCB);
	glutReshapeFunc(Solution::winResizeCB);
	glutKeyboardFunc(Solution::keyboardCB);
	glutSpecialFunc(Solution::specialKeyboardCB);
	glutPassiveMotionFunc(Solution::passiveMouseCB);
	glutTimerFunc(FRAME_TIME, Solution::timerCB, UPDATE_RENDERRED_OBJECTS);
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

	// create a menu
	createMenu();

	checkGLError();


	GLenum res = glewInit();
	if (res != GLEW_OK) {
		printf("Error - %s \n", glewGetErrorString(res));
		return (-1);
	}


	return 0;
}

/************************************************************/

// render callback function.  This is a static funcion


void Solution::renderCB()
{

	sol->render();
	
}


/************************************************************/

// keyboard callback function.  This is a static funcion


void Solution::passiveMouseCB(int x, int y)
{
	sol->passiveMouse(x, y);
}


/************************************************************/

// keyboard callback function.  This is a static funcion


void Solution::keyboardCB(unsigned char key, int x, int y)
{
	sol->keyboard(key, x, y);
}


/************************************************************/

// special keyboard callback function.  This is a static funcion



void Solution::specialKeyboardCB(int key, int x, int y)
{
	sol->specialKeyboard(key, x, y);
}


/************************************************************/

// window resize callback function.  This is a static funcion



void Solution::winResizeCB(int width, int height)
{
	sol->winResize(width, height);
}

/************************************************************/

// timer  callback function.  This is a static funcion


void Solution::timerCB(int operation)
{
	
	glutTimerFunc(FRAME_TIME, Solution::timerCB, UPDATE_RENDERRED_OBJECTS);	
	sol->timer(operation);

}


/************************************************************/

// timrt  function.  


int Solution::timer(int operation)
{
	switch (operation) {
	case UPDATE_RENDERRED_OBJECTS:
		updateObjects(FRAME_TIME / 1000.0f);
		break;
	default:
		break;
	}
	return(0);
}




/******************************************************************************/
// initialization of the solution
int Solution::initSolution()
{
	int rc;
	Vertices vtx;
	Indices ind;

	checkGLError();

	// create particle shader object
	
	rc = emit_particle_shader.createShaderProgram("emit_particle_shader.vs", "particle_shader.fs");
	if (rc != 0) {
		fprintf(stderr, "Error in generating particle shader (solution)\n");
		rc = -1;
		goto err;
	}
	checkGLError();

	emit_particle_shader_id = emit_particle_shader.getProgId();


	// create floor shader object

	rc = floor_shader.createShaderProgram("floor_shader.vs", "floor_shader.fs");
	if (rc != 0) {
		fprintf(stderr, "Error in generating floor shader (solution)\n");
		rc = -1;
		goto err;
	}
	checkGLError();

	floor_shader_id = floor_shader.getProgId();

	// create cube shader object
	cube_shader.createShaderProgram("cube_shader.vs", "cube_shader.fs");
	if (rc != 0) {
		fprintf(stderr, "Error in generating cube shader (solution)\n");
		rc = -1;
		goto err;
	}
	checkGLError();

	cube_shader_id = cube_shader.getProgId();


	// emit particle
	// create geometry
	point_emit_particles.createGeom(emit_particle_shader);
	plane_emit_particles.createGeom(emit_particle_shader);
	cube_emit_particles.createGeom(emit_particle_shader);
	flame_emit_particles.createGeom(emit_particle_shader);
	smoke_emit_particles.createGeom(emit_particle_shader);

	// set model position
	point_emit_particles.setModelPosition(0, 0, 0);
	plane_emit_particles.setModelPosition(0, 0, 0);
	cube_emit_particles.setModelPosition(0, 0, 0);
	flame_emit_particles.setModelPosition(0, 0, 0);
	smoke_emit_particles.setModelPosition(0, 0, 0);

	// set world position
	point_emit_particles.setWorldPosition(Vector3f(0, 0, 0));
	plane_emit_particles.setWorldPosition(Vector3f(0, 0, 0));
	cube_emit_particles.setWorldPosition(Vector3f(0, 0, 0));
	flame_emit_particles.setWorldPosition(Vector3f(0, 0, 0));
	smoke_emit_particles.setWorldPosition(Vector3f(0, 0, 0));

	// Floor
	floor_object.createGeom(floor_shader);
	floor_object.setModelPosition(0, 0, 0);
	floor_object.setModelScale(1000, 1, 1000);
	floor_object.setWorldPosition(Vector3f(0, -100, 0));

	// Cube
	cube_object.createGeom(cube_shader);
	cube_object.setModelPosition(0, 0, 0);
	cube_object.setModelScale(10, 10, 10);
	cube_object.setWorldPosition(Vector3f(0, 0, 0));

	// set the camera initial position
	cam.setCamera(Vector3f(0, 0, 100), Vector3f(0, 0, 0), Vector3f(0, 1, 0));

err:
	return 0;
}


/**********************************************************************/

void Solution::setSolution(Solution * _sol)
{
	Solution::sol = _sol;
}



/************************************************************/

// render function.  


int Solution::render()
{

	Vector3f viewerPosition;
	Vector3f lookAtPoint;
	Vector3f upVector;;
	Matrix4f viewMat, projMat;
	int location = 0;
	

	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	if (!plotWireFrame) glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);


	// camera

	// get the camera matrix from the camera
	viewMat = cam.getViewMatrix(NULL);	// get the camera view transformation

	// set the projection matrix
	projMat = cam.getProjectionMatrix(NULL);


	// Floor --------------------------------------------------------//

	// Floor Shader
	glUseProgram(floor_shader_id);

	// get the location of the matrix
	location = glGetUniformLocation(floor_shader_id, "view");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, viewMat.data());

	// get the location of the matrix
	location = glGetUniformLocation(floor_shader_id, "projection");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, projMat.data());

	floor_object.render(floor_shader);


	// Cube --------------------------------------------------------//

	// Cube Shader
	glUseProgram(cube_shader_id);

	// get the location of the matrix
	location = glGetUniformLocation(cube_shader_id, "view");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, viewMat.data());

	// get the location of the matrix
	location = glGetUniformLocation(cube_shader_id, "projection");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, projMat.data());

	if (render_cube) {
		cube_object.render(cube_shader);
	}


	// Emit Particles --------------------------------------------------------//

	// Emit Shader
	// use particle shader
	glUseProgram(emit_particle_shader_id);

	// get the location of the matrix
	location = glGetUniformLocation(emit_particle_shader_id, "view");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, viewMat.data());

	// get the location of the matrix
	location = glGetUniformLocation(emit_particle_shader_id, "projection");

	assert(location != -1);
	if (location == -1) return (-1);

	// transfer the matrix to the shader program
	glUniformMatrix4fv(location, 1, GL_TRUE, projMat.data());


	// render the particles
	if (render_particles) {
		switch (rendering) {
		case RENDER_POINT_EMIT_PARTICLES:
			point_emit_particles.render(emit_particle_shader);
			break;
		case RENDER_PLANE_EMIT_PARTICLES:
			plane_emit_particles.render(emit_particle_shader);
			break;
		case RENDER_CUBE_EMIT_PARTICLES:
			cube_emit_particles.render(emit_particle_shader);
			break;
		case RENDER_FLAME_EMIT_PARTICLES:
			flame_emit_particles.render(emit_particle_shader);
			break;
		case RENDER_SMOKE_EMIT_PARTICLES:
			smoke_emit_particles.render(emit_particle_shader);
			break;
		}
	}

	glutSwapBuffers();
	return (0);
}


/************************************************************/

// passive motion function. 


void Solution::passiveMouse(int x, int y)

{
	int winid = glutGetWindow();
	//std::cout << "Passive Mouse winId=" << winid << "(" << x << " , " << y << ")" << std::endl;
}

/************************************************************/

// keyboard handling function. 

void Solution::keyboard(unsigned char key, int x, int y)
{
	static int nc = 0;
	nc++;
	switch (key) {
	case 'w':
		cam.moveForward(NORMAL_SPEED);
		break;
	case 's':
		cam.moveBackward(NORMAL_SPEED);
		break;
	case 'd':
		cam.moveRight(NORMAL_SPEED);
		break;
	case 'a':
		cam.moveLeft(NORMAL_SPEED);
		break;
	case 'r':
		cam.moveUp(NORMAL_SPEED);
		break;
	case 'f':
		cam.moveDown(NORMAL_SPEED);
		break;
	case 'q':
		cam.roll(NORMAL_SPEED / 2);
		break;
	case 'e':
		cam.roll(-NORMAL_SPEED / 2);
		break;
	case 'c':
		break;
	case 'z':
		cam.zoomIn();
		break;
	case 'x':
		cam.zoomOut();
		break;
	case '0':
		menuFunCB(CUBE_MOVE_CENTER);
		break;
	case '1':
		menuFunCB(CUBE_MOVE_RIGHT_1);
		break;
	case '2':
		menuFunCB(CUBE_MOVE_RIGHT_2);
		break;
	case '3':
		menuFunCB(CUBE_MOVE_RIGHT_3);
		break;
	case '4':
		menuFunCB(CUBE_MOVE_FRONT_1);
		break;
	case '5':
		menuFunCB(CUBE_MOVE_FRONT_2);
		break;
	case '6':
		menuFunCB(CUBE_MOVE_FRONT_3);
		break;
	case '7':
		menuFunCB(CUBE_MOVE_BACK_1);
		break;
	case '8':
		menuFunCB(CUBE_MOVE_BACK_2);
		break;
	case '9':
		menuFunCB(CUBE_MOVE_BACK_3);
		break;
	case '-':
		menuFunCB(TOGGLE_CUBE);
		break;
	case '=':
		menuFunCB(TOGGLE_PARTICLES);
		break;
	case 'y':
		menuFunCB(RENDER_POINT_EMIT_PARTICLES);
		break;
	case 'u':
		menuFunCB(RENDER_PLANE_EMIT_PARTICLES);
		break;
	case 'i':
		menuFunCB(RENDER_CUBE_EMIT_PARTICLES);
		break;
	case 'o':
		menuFunCB(RENDER_FLAME_EMIT_PARTICLES);
		break;
	case 'p':
		menuFunCB(RENDER_SMOKE_EMIT_PARTICLES);
		break;
	case 'g':
		menuFunCB(PARTICLE_ROTATE_UP);
		break;
	case 'h':
		menuFunCB(PARTICLE_ROTATE_UP_RIGHT);
		break;
	case 'j':
		menuFunCB(PARTICLE_ROTATE_RIGHT);
		break;
	case 'k':
		menuFunCB(PARTICLE_ROTATE_DOWN_RIGHT);
		break;
	case 'l':
		menuFunCB(PARTICLE_ROTATE_DOWN);
		break;
	}
}

/************************************************************/

// special keyboard handling  function.  


void Solution::specialKeyboard(int key, int x, int y)
{
	switch (key) {
	case 033:
	case GLUT_KEY_LEFT:
		cam.yaw(NORMAL_SPEED / 2);
		break;
	case GLUT_KEY_UP:
		cam.pitch(NORMAL_SPEED / 2);
		break;
	case GLUT_KEY_RIGHT:
		cam.yaw(-NORMAL_SPEED / 2);
		break;
	case GLUT_KEY_DOWN:
		cam.pitch(-NORMAL_SPEED / 2);
		break;
	}
}


/************************************************************/

// window resize handling function.  



void Solution::winResize(int width, int height)
{
	glViewport(0, 0, width, height);


}

/***********************************************************/
// update the state of the objects

int Solution::updateObjects(float delta_time)
{
	point_emit_particles.update(delta_time);
	plane_emit_particles.update(delta_time);
	cube_emit_particles.update(delta_time);
	flame_emit_particles.update(delta_time);
	smoke_emit_particles.update(delta_time);
	glutPostRedisplay();
	return 0;
}




/******************************************************************************/
/* purpose: Creates a menu and a sub menuassigns it to the right mouse button*/

void Solution::createMenu(void) {

	// create emit particles menu
	int emit_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("point particles", RENDER_POINT_EMIT_PARTICLES);
	glutAddMenuEntry("plane particles", RENDER_PLANE_EMIT_PARTICLES);
	glutAddMenuEntry("cube particles", RENDER_CUBE_EMIT_PARTICLES);
	glutAddMenuEntry("flame particles", RENDER_FLAME_EMIT_PARTICLES);
	glutAddMenuEntry("smoke particles", RENDER_SMOKE_EMIT_PARTICLES);

	// create particle rotation menu
	int particle_rotate_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("Up", PARTICLE_ROTATE_UP);
	glutAddMenuEntry("Up Right", PARTICLE_ROTATE_UP_RIGHT);
	glutAddMenuEntry("Right", PARTICLE_ROTATE_RIGHT);
	glutAddMenuEntry("Down Right", PARTICLE_ROTATE_DOWN_RIGHT);
	glutAddMenuEntry("Down", PARTICLE_ROTATE_DOWN);

	// create particle scale menu
	int particle_scale_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("small", PARTICLE_SCALE_SMALL);
	glutAddMenuEntry("normal", PARTICLE_SCALE_NORMAL);
	glutAddMenuEntry("large", PARTICLE_SCALE_LARGE);

	// create cube move right menu
	int cube_translate_right_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("right", CUBE_MOVE_RIGHT_1);
	glutAddMenuEntry("further right", CUBE_MOVE_RIGHT_2);
	glutAddMenuEntry("far right", CUBE_MOVE_RIGHT_3);

	// create cube move front menu
	int cube_translate_front_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("front", CUBE_MOVE_FRONT_1);
	glutAddMenuEntry("further front", CUBE_MOVE_FRONT_2);
	glutAddMenuEntry("far front", CUBE_MOVE_FRONT_3);

	// create cube move back menu
	int cube_translate_back_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("back", CUBE_MOVE_BACK_1);
	glutAddMenuEntry("further back", CUBE_MOVE_BACK_2);
	glutAddMenuEntry("far back", CUBE_MOVE_BACK_3);

	// create cube translation menu
	int cube_translate_menu_id = glutCreateMenu(menuFunCB);
	glutAddMenuEntry("center", CUBE_MOVE_CENTER);
	glutAddSubMenu("right", cube_translate_right_menu_id);
	glutAddSubMenu("front", cube_translate_front_menu_id);
	glutAddSubMenu("back", cube_translate_back_menu_id);

	// create the main menu
	int menu_id = glutCreateMenu(menuFunCB);
	//glutAddMenuEntry("Clear Screen", CLEAR_SCREEN);
	glutAddSubMenu("Render Emit Particles", emit_menu_id);
	glutAddSubMenu("Rotate particles", particle_rotate_menu_id);
	glutAddSubMenu("Scale particle system", particle_scale_menu_id);
	glutAddMenuEntry("Toggle Particles", TOGGLE_PARTICLES);
	glutAddMenuEntry("Toggle Cube", TOGGLE_CUBE);
	glutAddSubMenu("Move cube", cube_translate_menu_id);
	glutAddMenuEntry("Quit", EXIT_PROGRAM);
	glutAttachMenu(GLUT_RIGHT_BUTTON);
}

/******************************************************************************/
/* purpose: Processes the response from the GLUT menu entry

Note that the function asigns to a global variable the optin that the user wanted

*/

void Solution::menuFunCB(int num) 
{
	int winId;
	switch (num) {
	case EXIT_PROGRAM:
		winId = glutGetWindow();
		glutDestroyWindow(winId);
		exit(0);
		break;
	
	// emit particles menu
	case RENDER_POINT_EMIT_PARTICLES:
		sol->rendering = RENDER_POINT_EMIT_PARTICLES;
		break;
	case RENDER_PLANE_EMIT_PARTICLES:
		sol->rendering = RENDER_PLANE_EMIT_PARTICLES;
		break;
	case RENDER_CUBE_EMIT_PARTICLES:
		sol->rendering = RENDER_CUBE_EMIT_PARTICLES;
		break;
	case RENDER_FLAME_EMIT_PARTICLES:
		sol->rendering = RENDER_FLAME_EMIT_PARTICLES;
		break;
	case RENDER_SMOKE_EMIT_PARTICLES:
		sol->rendering = RENDER_SMOKE_EMIT_PARTICLES;
		break;

	// object toggle
	case TOGGLE_PARTICLES:
		sol->render_particles = !sol->render_particles;
		break;
	case TOGGLE_CUBE:
		sol->render_cube = !sol->render_cube;
		break;

	// emit rotation menu
	case PARTICLE_ROTATE_UP:
		sol->point_emit_particles.setWorldRotations(0, 0, 0);
		sol->point_emit_particles.setWorldRotations(0, 0, 0);
		sol->plane_emit_particles.setWorldRotations(0, 0, 0);
		sol->cube_emit_particles.setWorldRotations(0, 0, 0);
		sol->flame_emit_particles.setWorldRotations(0, 0, 0);
		sol->smoke_emit_particles.setWorldRotations(0, 0, 0);
		break;
	case PARTICLE_ROTATE_UP_RIGHT:
		sol->point_emit_particles.setWorldRotations(-45, 0, 0);
		sol->point_emit_particles.setWorldRotations(-45, 0, 0);
		sol->plane_emit_particles.setWorldRotations(-45, 0, 0);
		sol->cube_emit_particles.setWorldRotations(-45, 0, 0);
		sol->flame_emit_particles.setWorldRotations(-45, 0, 0);
		sol->smoke_emit_particles.setWorldRotations(-45, 0, 0);
		break;
	case PARTICLE_ROTATE_RIGHT:
		sol->point_emit_particles.setWorldRotations(-90, 0, 0);
		sol->point_emit_particles.setWorldRotations(-90, 0, 0);
		sol->plane_emit_particles.setWorldRotations(-90, 0, 0);
		sol->cube_emit_particles.setWorldRotations(-90, 0, 0);
		sol->flame_emit_particles.setWorldRotations(-90, 0, 0);
		sol->smoke_emit_particles.setWorldRotations(-90, 0, 0);
		break;
	case PARTICLE_ROTATE_DOWN_RIGHT:
		sol->point_emit_particles.setWorldRotations(-135, 0, 0);
		sol->point_emit_particles.setWorldRotations(-135, 0, 0);
		sol->plane_emit_particles.setWorldRotations(-135, 0, 0);
		sol->cube_emit_particles.setWorldRotations(-135, 0, 0);
		sol->flame_emit_particles.setWorldRotations(-135, 0, 0);
		sol->smoke_emit_particles.setWorldRotations(-135, 0, 0);
		break;
	case PARTICLE_ROTATE_DOWN:
		sol->point_emit_particles.setWorldRotations(-180, 0, 0);
		sol->point_emit_particles.setWorldRotations(-180, 0, 0);
		sol->plane_emit_particles.setWorldRotations(-180, 0, 0);
		sol->cube_emit_particles.setWorldRotations(-180, 0, 0);
		sol->flame_emit_particles.setWorldRotations(-180, 0, 0);
		sol->smoke_emit_particles.setWorldRotations(-180, 0, 0);
		break;

	// emit scale menu
	case PARTICLE_SCALE_SMALL:
		sol->point_emit_particles.setModelScale(0.5, 0.5, 0.5);
		sol->point_emit_particles.setModelScale(0.5, 0.5, 0.5);
		sol->plane_emit_particles.setModelScale(0.5, 0.5, 0.5);
		sol->cube_emit_particles.setModelScale(0.5, 0.5, 0.5);
		sol->flame_emit_particles.setModelScale(0.5, 0.5, 0.5);
		sol->smoke_emit_particles.setModelScale(0.5, 0.5, 0.5);
		break;
	case PARTICLE_SCALE_NORMAL:
		sol->point_emit_particles.setModelScale(1.0, 1.0, 1.0);
		sol->point_emit_particles.setModelScale(1.0, 1.0, 1.0);
		sol->plane_emit_particles.setModelScale(1.0, 1.0, 1.0);
		sol->cube_emit_particles.setModelScale(1.0, 1.0, 1.0);
		sol->flame_emit_particles.setModelScale(1.0, 1.0, 1.0);
		sol->smoke_emit_particles.setModelScale(1.0, 1.0, 1.0);
		break;
	case PARTICLE_SCALE_LARGE:
		sol->point_emit_particles.setModelScale(5.0, 5.0, 5.0);
		sol->point_emit_particles.setModelScale(5.0, 5.0, 5.0);
		sol->plane_emit_particles.setModelScale(5.0, 5.0, 5.0);
		sol->cube_emit_particles.setModelScale(5.0, 5.0, 5.0);
		sol->flame_emit_particles.setModelScale(5.0, 5.0, 5.0);
		sol->smoke_emit_particles.setModelScale(5.0, 5.0, 5.0);
		break;

	// cube translation menu
	case CUBE_MOVE_CENTER:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, 0));
		break;
	case CUBE_MOVE_RIGHT_1:
		sol->cube_object.setWorldPosition(Vector3f(10, 0, 0));
		break;
	case CUBE_MOVE_RIGHT_2:
		sol->cube_object.setWorldPosition(Vector3f(20, 0, 0));
		break;
	case CUBE_MOVE_RIGHT_3:
		sol->cube_object.setWorldPosition(Vector3f(50, 0, 0));
		break;
	case CUBE_MOVE_FRONT_1:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, 10));
		break;
	case CUBE_MOVE_FRONT_2:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, 20));
		break;
	case CUBE_MOVE_FRONT_3:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, 50));
		break;
	case CUBE_MOVE_BACK_1:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, -10));
		break;
	case CUBE_MOVE_BACK_2:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, -20));
		break;
	case CUBE_MOVE_BACK_3:
		sol->cube_object.setWorldPosition(Vector3f(0, 0, -50));
		break;

	case RENDER_FILLED:
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		break;
	case RENDER_WIREFRAME:
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		break;

	default: 
		break;
	}
	glutPostRedisplay();

}

/***********************************************************/
// update the state of the objects

/*************************************************************************************************************/

int Solution::printOpenGLError(int errorCode)
{
	switch (errorCode) {
	case GL_INVALID_VALUE:
		printf("GL_INVALID_VALUE is generated if program is not a value generated by OpenGL.\n");
		break;
	case GL_INVALID_OPERATION:
		printf("GL_INVALID_OPERATION is generated if program is not a program object. or \n");
		printf("GL_INVALID_OPERATION is generated if program has not been successfully linked. or \n");
		printf("GL_INVALID_OPERATION is generated if location does not correspond to a valid uniform variable location for the specified program object.\n");
		break;
	default:
		printf("openGL unknown error \n");
	}

	clearGLError();

	return 0;
}

/*************************************************************************************************************/

int Solution::clearGLError()
{
	for (int i = 0; i < 20; i++) {
		int rc = glGetError();
		if (rc != GL_NO_ERROR) {
			switch (rc) {
			case GL_INVALID_VALUE:
				printf("GL_INVALID_VALUE is generated if program is not a value generated by OpenGL.\n");
				break;
			case GL_INVALID_OPERATION:
				printf("GL_INVALID_OPERATION is generated if program is not a program object. or \n");
				printf("GL_INVALID_OPERATION is generated if program has not been successfully linked. or \n");
				printf("GL_INVALID_OPERATION is generated if location does not correspond to a valid uniform variable location for the specified program object.");
				break;
			default:
				printf("openGL unknown error \n");
			}
		}
		else break;
	}

	return 0;
}

/*************************************************************************************************************/

int Solution::checkGLError()
{
	int rc = glGetError();
	if (rc != GL_NO_ERROR) {
		printOpenGLError(rc);
		clearGLError();
	}

	return 0;
}
