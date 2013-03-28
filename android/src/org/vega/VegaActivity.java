package org.vega;

import android.app.NativeActivity;

/**
 * The Activity that runs the Vega engine. When declare it in the Android manifest file, don't
 * forget to add the tag 'meta-data' with parameters android:name="android.app.lib_name" and
 * android:value="vega" to link the Activity with the Vega native library.
 * @author MARCIO
 *
 */
public class VegaActivity extends NativeActivity {
	
	static {
		System.loadLibrary("stlport_shared");
		System.loadLibrary("lua");
		System.loadLibrary("vega");
	}
	
	/**
	 * Sets the name of the script to load and execute. Please override the onCreate method and set the script
	 * before call super.onCreate.
	 */
	public native void setScriptToLoadAndExecute(String scriptName);

}
