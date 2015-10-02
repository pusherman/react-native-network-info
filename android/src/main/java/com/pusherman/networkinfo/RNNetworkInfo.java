package com.pusherman.networkinfo;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.Map;

public class RNNetworkInfo extends ReactContextBaseJavaModule {

  public RNNetworkInfo(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "RNNetworkInfo";
  }

  @ReactMethod
  public void getSSID(final Callback callback) {
  	callback.invoke("Placeholder_ssid");
  }

  @ReactMethod
  public void getIPAddress(final Callback callback) {
  	callback.invoke("0.0.0.0");
  }

}
