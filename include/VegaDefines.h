#ifndef VEGAENGINE_VEGADEFINES_H
#define VEGAENGINE_VEGADEFINES_H

#include <iostream>
#include "SDL.h"
#include "Functions.h"

#define INITAPP(startModuleScriptName) \
	int main(int argc, char** argv) \
	{ \
		VegaInit(); \
		VegaLoop(startModuleScriptName); \
		VegaFinish(); \
		return 0; \
	}

#endif
