#pragma once
#ifndef SOLUTION_HEADER
#define SOLUTION_HEADER



//=============================================================================
// solution.h
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




#include "GL/glew.h"
#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include "GL/glut.h"
#endif

#include "config.h"

#include "Shader.h"
#include "floor_object.h"
#include "cube_object.h"
#include "emit_particles.h"
#include "point_emit_particles.h"
#include "plane_emit_particles.h"
#include "cube_emit_particles.h"
#include "flame_emit_particles.h"
#include "smoke_emit_particles.h"
#include "camera.h"
#include "GL/nuss_math.h"


/************************************************************************************************/
// STRUCTURES

class Solution
{
public:
	Solution();
	~Solution();
	// initializing the opengl functions and windows
	int initOpenGL(int argc, char** argv, int posX, int posY, int winWidth, int winHeight);


	// static callback function 
	static void renderCB();
	static void passiveMouseCB(int x, int y);
	static void keyboardCB(unsigned char key, int x, int y);
	static void specialKeyboardCB(int key, int x, int y);
	static void winResizeCB(int width, int height);
	static void timerCB(int operation);
	static void menuFunCB(int num);

	static void setSolution(Solution * _sol);

	// generaL shader that will be used by all objects
	// initialization of the solution
	int initSolution();


	
	
private:
	static Solution* sol;

	// Shaders
	Shader emit_particle_shader;
	int emit_particle_shader_id;

	// Floor shaders
	Shader floor_shader;
	int floor_shader_id;

	// Cube shaders
	Shader cube_shader;
	int cube_shader_id;

	// Basic Particles
	PointEmitParticles point_emit_particles;
	PlaneEmitParticles plane_emit_particles;
	CubeEmitParticles cube_emit_particles;
	// Specific Particles
	FlameEmitParticles flame_emit_particles;
	SmokeEmitParticles smoke_emit_particles;

	// Floor
	FloorObject floor_object;

	// Cube
	CubeObject cube_object;

	Camera cam;

	int rendering = RENDER_SMOKE_EMIT_PARTICLES;
	bool render_particles = true;
	bool render_cube = false;

	int plotWireFrame;		// plot in wireframe of filled polyogns == 1
	int plotCorrect;	// plot correctly with normal matrix

	int render();
	void keyboard(unsigned char key, int x, int y);

	void passiveMouse(int x, int y);

	void specialKeyboard(int key, int x, int y);
	void winResize(int width, int height);
	int timer(int operation);

	void createMenu(void);
	int updateObjects(float delta_time);

	int printOpenGLError(int errorCode);
	int clearGLError();
	int checkGLError();
};



#endif