#include "../include/Texture.h"

using namespace vega;

/**
Loads the image with the given file name, creates the texture and returns it.
*/
Texture* Texture::Load(std::string filename)
{
	Texture *texture = new Texture();
	texture->surface = IMG_Load(filename.c_str());
	if (!texture)
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
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		SDL_LockSurface(texture->surface);
		glTexImage2D(GL_TEXTURE_2D, 0, 4, texture->surface->w, texture->surface->h, 0, texture->GetOpenGLTextureFormat(), GL_UNSIGNED_BYTE, texture->surface->pixels);
		SDL_UnlockSurface(texture->surface);
	}
	return texture;
}

Texture::Texture() : surface(NULL), glTextureName(0)
{
}

Texture::~Texture()
{
	if (surface)
		SDL_FreeSurface(surface);
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
