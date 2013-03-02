#ifndef VEGAENGINE_TEXTURE_H
#define VEGAENGINE_TEXTURE_H

#include "SDL.h"
#include "OpenGL.h"
#include <string>

namespace vega
{
	/**
	A texture object. Handles the image data and the openGL texture. Creates a texture with the Load static method.
	*/
	class Texture
	{
	public:
		static Texture* Load(std::string filename);
		virtual ~Texture();
		GLuint GetOpenGLTextureName();
		int GetWidth();
		int GetHeight();
	private:
		Texture();
		SDL_Surface *surface;
		GLuint glTextureName;
		GLenum GetOpenGLTextureFormat();
	};
}

#endif
