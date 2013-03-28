#include "../include/Log.h"
#include "../include/VegaDefines.h"

#ifdef VEGA_WINDOWS

#include <iostream>

using namespace std;
using namespace vega;

void Log::Info(std::string message)
{
	cout << message << endl;
}

void Log::Error(std::string message)
{
	cerr << message << endl;
}

#endif
