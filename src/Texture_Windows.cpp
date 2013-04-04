#include "../include/Texture.h"

#ifdef VEGA_WINDOWS

using namespace vega;
using namespace std;

/**
Returns the width of the texture image.
*/
int Texture::GetWidth()
{
	return surface == NULL ? 0 : surface->w;
}

/**
Returns the height of the texture image.
*/
int Texture::GetHeight()
{
	return surface == NULL ? 0 : surface->h;
}

/**
Returns the texture format to be used with OpenGL. Only RGB and RGBA are correctly accepted.
*/
GLenum Texture::GetOpenGLTextureFormat()
{
    if (surface->format->BytesPerPixel==3)
        return GL_RGB;
    else
        return GL_RGBA;
}

/**
Returns the pixel data. Always lock the texture before call this method and unlock after use the
texture data.
*/
void* Texture::GetData()
{
	return surface->pixels;
}

/**
Lock the texture to allow the access to the pixel data with the GetData function.
*/
void Texture::Lock()
{
	SDL_LockSurface(surface);
}

/**
Unlock the pixel data. Call it after call Lock and GetData functions.
*/
void Texture::Unlock()
{
	SDL_UnlockSurface(surface);
}

/**
Initializes the texture data loading from the file using SDL_Image lib.
Returns true if loaded with success.
*/
bool Texture::LoadData(string filename)
{
	surface = IMG_Load(filename.c_str());
	return surface != NULL;
}

#endif
