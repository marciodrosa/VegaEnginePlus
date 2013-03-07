#ifndef VEGAENGINE_VEGADEFINES_H
#define VEGAENGINE_VEGADEFINES_H

#include <iostream>
#include "SDL.h"
#include "App.h"

#define INITAPP(scriptName) \
	int main(int argc, char** argv) \
	{ \
		vega::App app; \
		app.LoadAndExecuteScript(scriptName); \
		return 0; \
	}

#endif
