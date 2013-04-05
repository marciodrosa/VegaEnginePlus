package org.vega;

import java.io.InputStream;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

/**
 * Class used by Vega to load image files from the assets folder. This load
 * function is implemented in Java because the lack of appropriate functions
 * to do that when using Android NDK (C code).
 */
public class ImageLoader {
	
	private Context context;
	
	public ImageLoader(Context context) {
		this.context = context;
	}

	/**
	 * Loads the bitmap from the assets folder. It also scales the image to the width and height be power of 2.
	 * @param fileName the name of the image file
	 * @return the loaded bitmap, of null if the image can't be loaded
	 */
	public Bitmap load(String fileName) {
		Bitmap bitmap = null;
		AssetManager assetManager = context.getAssets();
		InputStream inputStream = null;
		try {
			inputStream = assetManager.open(fileName);
			bitmap = BitmapFactory.decodeStream(inputStream);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
		}
		return createPowerOf2ScaledBitmap(bitmap);
	}
	
	public Bitmap createPowerOf2ScaledBitmap(Bitmap bitmap) {
		int newWidth = getNearestPowerOf2Value(bitmap.getWidth());
		int newHeight = getNearestPowerOf2Value(bitmap.getHeight());
		if (bitmap.getWidth() == newWidth && bitmap.getHeight() == newHeight)
			return bitmap;
		else
			return Bitmap.createScaledBitmap(bitmap, newWidth, newHeight, true);
	}
	
	public int getNearestPowerOf2Value(int value) {
		int above = value - 1;
		above |= above >> 1;
		above |= above >> 2;
		above |= above >> 4;
		above |= above >> 8;
		above |= above >> 16;
		above++;
		int below = above >> 1;
		return (above - value) < (value - below) ? above : below;
	}
}



