#include "../include/Texture.h"
#include "../include/Log.h"
#include "../include/App.h"

#ifdef VEGA_ANDROID

using namespace vega;
using namespace std;

/**
Returns the width of the texture image.
*/
int Texture::GetWidth()
{
	return bitmapInfo.width;
}

/**
Returns the height of the texture image.
*/
int Texture::GetHeight()
{
	return bitmapInfo.height;
}

/**
Returns the texture format to be used with OpenGL. Only RGB and RGBA are correctly accepted.
*/
GLenum Texture::GetOpenGLTextureFormat()
{
	if (bitmapInfo.format == ANDROID_BITMAP_FORMAT_RGBA_8888)
		return GL_RGBA;
	else
		return GL_RGB;
}

/**
Returns the pixel data. Always lock the texture before call this method and unlock after use the
texture data.
*/
void* Texture::GetData()
{
	return pixelData;
}

/**
Lock the texture to allow the access to the pixel data with the GetData function.
*/
void Texture::Lock()
{
	AndroidBitmap_lockPixels(javaEnv, javaBitmap, &pixelData);
}

/**
Unlock the pixel data. Call it after call Lock and GetData functions.
*/
void Texture::Unlock()
{
	AndroidBitmap_unlockPixels(javaEnv, javaBitmap);
}

/**
Initializes the texture data loading from the file using Java code.
Returns true if loaded with success.
*/
bool Texture::LoadData(string filename)
{
	Log::Info("Loading the texture:");
	Log::Info(filename);
	javaEnv = App::GetScriptThreadJavaEnv();

	// Accessing the Java image loader
	jobject javaActivityObject = App::GetAndroidActivity()->clazz;
	jmethodID getImageLoaderMethodId = javaEnv->GetMethodID(javaEnv->GetObjectClass(javaActivityObject), "getImageLoader", "()Lorg/vega/ImageLoader;");
	
	// Accessing the load method
	jobject javaImageLoaderObject = javaEnv->CallObjectMethod(javaActivityObject, getImageLoaderMethodId);
	jmethodID loadMethodId = javaEnv->GetMethodID(javaEnv->GetObjectClass(javaImageLoaderObject), "load", "(Ljava/lang/String;)Landroid/graphics/Bitmap;");
	
	// Calling the load method
	jstring javaFilename = javaEnv->NewStringUTF(filename.c_str());
	javaBitmap = javaEnv->CallObjectMethod(javaImageLoaderObject, loadMethodId, javaFilename);
	
	if (javaBitmap)
	{
		javaBitmap = javaEnv->NewGlobalRef(javaBitmap);
		AndroidBitmap_getInfo(javaEnv, javaBitmap, &bitmapInfo);
		return true;
	}
	else
	{
		Log::Info("The load of the texture returned null.");
		return false;
	}
}

#endif
