#ifndef VEGAENGINE_VEGADEFINES_H
#define VEGAENGINE_VEGADEFINES_H

#include <iostream>
#include "SDL.h"
#include "Functions.h"

#define INITAPP(startComponentScriptName) \
	int main(int argc, char** argv) \
	{ \
		VegaInit(); \
		VegaLoop(startComponentScriptName); \
		VegaFinish(); \
		return 0; \
	}

#endif
