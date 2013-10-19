#include "../include/Texture.h"
#include "../include/Log.h"
#include "../include/lodepng/lodepng.h"
#include <sstream>

#ifdef VEGA_WINDOWS

using namespace vega;
using namespace std;

/**
Returns the width of the texture image.
*/
int Texture::GetWidth()
{
	return width;
}

/**
Returns the height of the texture image.
*/
int Texture::GetHeight()
{
	return height;
}

/**
Returns the texture format to be used with OpenGL. Only RGB and RGBA are correctly accepted.
*/
GLenum Texture::GetOpenGLTextureFormat()
{
    return GL_RGBA;
}

/**
Returns the pixel data. Always lock the texture before call this method and unlock after use the
texture data.
*/
void* Texture::GetData()
{
	return &imageData[0];
}

/**
Lock the texture to allow the access to the pixel data with the GetData function.
*/
void Texture::Lock()
{
}

/**
Unlock the pixel data. Call it after call Lock and GetData functions.
*/
void Texture::Unlock()
{
}

/**
Initializes the texture data loading from the file using SDL_Image lib.
Returns true if loaded with success.
*/
bool Texture::LoadData(string filename)
{
	unsigned error = lodepng::decode(imageData, width, height, filename.c_str());
	if (error)
	{
		stringstream ss;
		ss << "decoder error " << error << ": " << lodepng_error_text(error);
		Log::Error(ss.str());
		return false;
	}
	else
		return true;
}

#endif
