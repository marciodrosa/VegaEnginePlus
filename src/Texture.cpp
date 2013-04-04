#include "../include/Texture.h"
#include "../include/Log.h"

#include <sstream>
using namespace std;
using namespace vega;

/**
Loads the image with the given file name, creates the texture and returns it.
*/
Texture* Texture::Load(std::string filename)
{
	Texture *texture = new Texture();
	if (texture->LoadData(filename))
	{
		glGenTextures(1, &texture->glTextureName);
		glBindTexture(GL_TEXTURE_2D, texture->glTextureName);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		texture->Lock();
		GLenum format = texture->GetOpenGLTextureFormat();
		glTexImage2D(GL_TEXTURE_2D, 0, format, texture->GetWidth(), texture->GetHeight(), 0, format, GL_UNSIGNED_BYTE, texture->GetData());
		texture->Unlock();
	}
	else
	{
		delete texture;
		texture = NULL;
	}
	return texture;
}

Texture::Texture() :
#ifdef VEGA_WINDOWS
	surface(NULL),
#endif
#ifdef VEGA_ANDROID
	javaEnv(NULL),
	pixelData(NULL),
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
#ifdef VEGA_ANDROID
	if (javaBitmap)
		javaEnv->DeleteGlobalRef(javaBitmap);
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
