#include "../include/Texture.h"

using namespace vega;

/**
Loads the image with the given file name, creates the texture and returns it.
*/
Texture* Texture::Load(std::string filename)
{
	Texture *texture = new Texture();
	bool loadImageFileOk = false;
#ifdef VEGA_WINDOWS
	texture->surface = IMG_Load(filename.c_str());
	loadImageFileOk = texture->surface != NULL;
#endif
	if (!loadImageFileOk)
	{
		delete texture;
		texture = NULL;
	}
	else
	{
		glGenTextures(1, &texture->glTextureName);
		glBindTexture(GL_TEXTURE_2D, texture->glTextureName);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
#ifdef VEGA_WINDOWS
		SDL_LockSurface(texture->surface);
#endif
		glTexImage2D(GL_TEXTURE_2D, 0, 4, texture->GetWidth(), texture->GetHeight(), 0, texture->GetOpenGLTextureFormat(), GL_UNSIGNED_BYTE, texture->GetData());
#ifdef VEGA_WINDOWS
		SDL_UnlockSurface(texture->surface);
#endif
	}
	return texture;
}

Texture::Texture() :
#ifdef VEGA_WINDOWS
	surface(NULL),
#endif
	glTextureName(0)
{
}

Texture::~Texture()
{
#ifdef VEGA_WINDOWS
	if (surface)
		SDL_FreeSurface(surface);
#endif
	if (glIsTexture(glTextureName))
		glDeleteTextures(1, &glTextureName);
}

/**
Returns the OpenGL generated texture name.
*/
GLuint Texture::GetOpenGLTextureName()
{
	return glTextureName;
}

/**
Returns the width of the texture image.
*/
int Texture::GetWidth()
{
#ifdef VEGA_WINDOWS
	return surface == NULL ? 0 : surface->w;
#endif
}

/**
Returns the height of the texture image.
*/
int Texture::GetHeight()
{
#ifdef VEGA_WINDOWS
	return surface == NULL ? 0 : surface->h;
#endif
}

/**
Returns the texture format to be used with OpenGL. Only RGB and RGBA are correctly accepted.
*/
GLenum Texture::GetOpenGLTextureFormat()
{
#ifdef VEGA_WINDOWS
    if (surface->format->BytesPerPixel==3)
        return GL_RGB;
    else
        return GL_RGBA;
#endif
}

void* Texture::GetData()
{
#ifdef VEGA_WINDOWS
	return surface->pixels;
#endif
}
