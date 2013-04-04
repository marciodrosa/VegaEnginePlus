package org.vega;

import android.app.NativeActivity;

/**
 * The Activity that runs the Vega engine. When declare it in the Android manifest file, don't
 * forget to add the tag 'meta-data' with parameters android:name="android.app.lib_name" and
 * android:value="vega" to link the Activity with the Vega native library.
 */
public class VegaActivity extends NativeActivity {

	private ImageLoader imageLoader;
	private Thread appThread;
	private String scriptName;
	
	static {
		System.loadLibrary("stlport_shared");
		System.loadLibrary("lua");
		System.loadLibrary("vega");
	}
	
	/**
	 * Returns the object that loads image files from the assets folder.
	 * @return
	 */
	public ImageLoader getImageLoader() {
		if (imageLoader == null) {
			imageLoader = new ImageLoader(this);
		}
		return imageLoader;
	}
	
	public void setScriptName(String scriptName) {
		this.scriptName = scriptName;
	}
	
	public synchronized void executeScriptThread() {
		if (appThread == null) {
			appThread = new Thread() {
				public void run() {
					executeAppScript(scriptName);
					finish();
				}
			};
			appThread.start();
		}
	}
	
	private native void executeAppScript(String scriptName);
}
