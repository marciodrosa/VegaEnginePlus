#ifndef VEGAENGINE_VEGAENGINE_H
#define VEGAENGINE_VEGAENGINE_H

#include <iostream>
#include "SDL.h"
#include "VegaFunctions.h"

#define INITAPP(scriptName, moduleObjectName) \
	int main(int argc, char** argv) \
	{ \
		VegaInit(); \
		VegaLoop(); \
		VegaFinish(); \
		return 0; \
	}

#endif
