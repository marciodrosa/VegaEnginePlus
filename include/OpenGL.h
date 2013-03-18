#ifndef VEGA_OPENGL_H
#define VEGA_OPENGL_H

// This header includes the OpenGL headers.

#include "VegaDefines.h"

#ifdef VEGA_WINDOWS
#include <windows.h>
#include <GL/GL.h>
#endif

#ifdef VEGA_ANDROID
#include <GLES/gl.h>
#include <GLES/glext.h>
#endif

#endif
