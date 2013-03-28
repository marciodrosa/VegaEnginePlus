#include "../include/Log.h"
#include "../include/VegaDefines.h"

#ifdef VEGA_ANDROID

using namespace std;
using namespace vega;

void Log::Info(std::string message)
{
	((void)__android_log_print(ANDROID_LOG_INFO, "vega", message.c_str()))
}

void Log::Error(std::string message)
{
	((void)__android_log_print(ANDROID_LOG_ERROR, "vega", message.c_str()))
}

#endif
