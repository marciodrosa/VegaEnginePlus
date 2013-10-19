#ifndef VEGA_TEXTURE_H
#define VEGA_TEXTURE_H

#include "Android.h"
#include "GLFW.h"
#include "OpenGL.h"
#include "VegaDefines.h"
#include <string>
#include <vector>

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
		GLenum GetOpenGLTextureFormat();
		void* GetData();
		void Lock();
		void Unlock();
		bool LoadData(std::string filename);

#ifdef VEGA_WINDOWS
		std::vector<unsigned char> imageData;
		unsigned width, height;
#endif

#ifdef VEGA_ANDROID
		JNIEnv* javaEnv;
		jobject javaBitmap;
		AndroidBitmapInfo bitmapInfo;
		void* pixelData;
#endif
		GLuint glTextureName;
	};
}

#endif
