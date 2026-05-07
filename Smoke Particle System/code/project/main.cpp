// main.cpp : Defines the entry point for the console application.
/*

File is the entry to program
*/


#include "Solution.h"


int main(int argc, char** argv)
{
	Solution sol;
	int posX = 0, posY= 0;	// windows position
	int winWidth = 500, winHeight = 500;	// window size

	sol.initOpenGL(argc, argv, posX, posY, winWidth, winHeight);
	sol.initSolution();
	Solution::setSolution(&sol);

	glutMainLoop();



	return 0;
}

