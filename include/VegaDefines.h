#ifndef VEGA_VEGADEFINES_H
#define VEGA_VEGADEFINES_H

#include <iostream>

#ifdef WIN32
#define VEGA_WINDOWS
#elif defined ANDROID
#define VEGA_ANDROID
#else
#error Undefined platform to build Vega. Define WIN32 or ANDROID.
#endif

#ifdef VEGA_ANDROID
#define VEGA_OPENGL_ES
#endif

#endif
