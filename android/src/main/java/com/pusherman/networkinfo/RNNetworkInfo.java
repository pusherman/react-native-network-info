package com.pusherman.networkinfo;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.support.annotation.NonNull;
import android.net.wifi.SupplicantState;
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
        // https://stackoverflow.com/a/34848930/5732760
        String ssid = "error";
        if (info.getSupplicantState() == SupplicantState.COMPLETED) {
            ssid = info.getSSID();
            if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
                ssid = ssid.substring(1, ssid.length() - 1);
            }
        }

        callback.invoke(ssid);
    }

    @ReactMethod
    public void getBSSID(final Callback callback) {
        WifiInfo info = wifi.getConnectionInfo();

        // https://stackoverflow.com/a/34848930/5732760
        String bssid = "error";
        if (info.getSupplicantState() == SupplicantState.COMPLETED) {
            bssid = wifi.getConnectionInfo().getBSSID();
        }

        callback.invoke(bssid);
    }

    @ReactMethod
    public void getBroadcast(/*@NonNull String ip, */final Callback callback) {
        String ipAddress = "error";

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress()/*address.getAddress().toString().equalsIgnoreCase(ip)*/) {
                ipAddress = address.getBroadcast().toString();
            }
        }

        callback.invoke(ipAddress);
    }

    @ReactMethod
    public void getIPAddress(final Callback callback) {
        String ipAddress = "error";

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress()) {
                ipAddress = address.getAddress().getHostAddress().toString();
            }
        }

        callback.invoke(ipAddress);
    }

    @ReactMethod
    public void getIPV4Address(final Callback callback) {
        String ipAddress = "0.0.0.0";

        for (InterfaceAddress address : getInetAddresses()) {
            if (!address.getAddress().isLoopbackAddress() && address.getAddress() instanceof Inet4Address) {
                ipAddress = address.getAddress().getHostAddress().toString();
            }
        }

        callback.invoke(ipAddress);
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
