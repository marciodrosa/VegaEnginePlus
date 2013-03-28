package org.vega.mainsample;

import org.vega.VegaActivity;

import android.os.Bundle;
import android.util.Log;

public class MainActivity extends VegaActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setScriptToLoadAndExecute("samplemaincomponent");
		Log.i("vega", "Creating the activity.");
		super.onCreate(savedInstanceState);
	}

}
