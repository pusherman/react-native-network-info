package com.pusherman.networkinfo;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.support.annotation.NonNull;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

public class RNNetworkInfo extends ReactContextBaseJavaModule {
    WifiManager wifi;

    public static final String TAG = "RNNetworkInfo";

    public RNNetworkInfo(ReactApplicationContext reactContext) {
        super(reactContext);

        wifi = (WifiManager) reactContext.getApplicationContext()
                .getSystemService(Context.WIFI_SERVICE);
    }

    @Override
    public String getName() {
        return TAG;
    }

    @ReactMethod
    public void getSSID(final Callback callback) {
        WifiInfo info = wifi.getConnectionInfo();

        // This value should be wrapped in double quotes, so we need to unwrap it.
        String ssid = info.getSSID();
        if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
            ssid = ssid.substring(1, ssid.length() - 1);
        }

        callback.invoke(ssid);
    }

    @ReactMethod
    public void getBSSID(final Callback callback) {
        callback.invoke(wifi.getConnectionInfo().getBSSID());
    }

    @ReactMethod
    public void getBroadcast(/*@NonNull String ip, */final Callback callback) {
        String ipAddress = null;

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress()/*address.getAddress().toString().equalsIgnoreCase(ip)*/) {
                ipAddress = address.getBroadcast().toString();
            }
        }

        callback.invoke(ipAddress);
    }

    @ReactMethod
    public void getIPAddress(final Callback callback) {
        String ipAddress = null;

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress()) {
                ipAddress = address.getAddress().getHostAddress().toString();
            }
        }

        callback.invoke(ipAddress);
    }

    @ReactMethod
    public void getIPV4Address(final Callback callback) {
        String ipAddress = null;

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress() && address.getAddress() instanceof Inet4Address) {
                ipAddress = address.getAddress().getHostAddress().toString();
            }
        }

        callback.invoke(ipAddress);
    }

    @ReactMethod
    public void getIPV4MacAddress(final Callback callback) {
        String mac = null;

        try {
        for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
            StringBuffer stringBuffer = new StringBuffer();                
            NetworkInterface networkInterface = en.nextElement();
            if (networkInterface != null) {
                byte[] bytes = networkInterface.getHardwareAddress();  
                if (bytes != null) {  
                for (int i = 0; i < bytes.length; i++) {  
                    if (i != 0) {  
                        stringBuffer.append("-");  
                    }  
                    int tmp = bytes[i] & 0xff;  
                    String str = Integer.toHexString(tmp);  
                    if (str.length() == 1) {  
                        stringBuffer.append("0" + str);  
                    } else {  
                        stringBuffer.append(str);  
                    }  
                }  
                mac = stringBuffer.toString().toUpperCase();
                } 
            }
            }
        } catch (Exception ex) {
        Log.e(TAG, ex.toString());
        }

        callback.invoke(mac);
    }

    private List<InterfaceAddress> getInetAddresses() {
        List<InterfaceAddress> addresses = new ArrayList<>();
        try {
            for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements(); ) {
                NetworkInterface intf = en.nextElement();

                for (InterfaceAddress interface_address : intf.getInterfaceAddresses()) {
                    addresses.add(interface_address);
                }
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());
        }
        return addresses;
    }
}
