package com.pusherman.networkinfo;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.net.wifi.SupplicantState;
import android.util.Log;

import com.facebook.react.bridge.Promise;
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
import java.util.Arrays;
import java.util.List;


public class RNNetworkInfo extends ReactContextBaseJavaModule {
    WifiManager wifi;

    public static final String TAG = "RNNetworkInfo";

    public static List<String> DSLITE_LIST = Arrays.asList("192.0.0.0", "192.0.0.1", "192.0.0.2", "192.0.0.3", "192.0.0.4", "192.0.0.5", "192.0.0.6", "192.0.0.7");


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
    public void getSSID(final Promise promise) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    WifiInfo info = wifi.getConnectionInfo();

                    // This value should be wrapped in double quotes, so we need to unwrap it.
                    // https://stackoverflow.com/a/34848930/5732760
                    String ssid = null;
                    if (info.getSupplicantState() == SupplicantState.COMPLETED) {
                        ssid = info.getSSID();
                        if (ssid.startsWith("\"") && ssid.endsWith("\"")) {
                            ssid = ssid.substring(1, ssid.length() - 1);
                        }
                    }
                    promise.resolve(ssid);
                } catch (Exception e) {
                    promise.resolve(null);
                }

            }
        }).start();
    }

    @ReactMethod
    public void getBSSID(final Promise promise) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    WifiInfo info = wifi.getConnectionInfo();

                    // https://stackoverflow.com/a/34848930/5732760
                    String bssid = null;
                    if (info.getSupplicantState() == SupplicantState.COMPLETED) {
                        bssid = wifi.getConnectionInfo().getBSSID();
                    }
                    promise.resolve(bssid);
                } catch (Exception e) {
                    promise.resolve(null);
                }

            }
        }).start();
    }

    @ReactMethod
    public void getBroadcast(final Promise promise) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String ipAddress = null;

                    for (InterfaceAddress address : getInetAddresses()) {
                        if (!address.getAddress().isLoopbackAddress()/*address.getAddress().toString().equalsIgnoreCase(ip)*/) {
                            ipAddress = address.getBroadcast().toString();
                        }
                    }
                    promise.resolve(ipAddress);
                } catch (Exception e) {
                    promise.resolve(null);
                }

            }
        }).start();
    }

    @ReactMethod
    public void getIPAddress(final Promise promise) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String ipAddress = null;
                    String tmp = "0.0.0.0";

                    for (InterfaceAddress address : getInetAddresses()) {
                        if (!address.getAddress().isLoopbackAddress()) {
                            tmp = address.getAddress().getHostAddress().toString();
                            if (!inDSLITERange(tmp)) {
                                ipAddress = tmp;
                            }
                        }
                    }
                    promise.resolve(ipAddress);
                } catch (Exception e) {
                    promise.resolve(null);
                }

            }
        }).start();

    }

    @ReactMethod
    public void getIPV4Address(final Promise promise) throws Exception {
        new Thread(new Runnable() {
            public void run() {
                try {
                    String ipAddress = null;
                    String tmp = "0.0.0.0";

                    for (InterfaceAddress address : getInetAddresses()) {
                        if (!address.getAddress().isLoopbackAddress() && address.getAddress() instanceof Inet4Address) {
                            tmp = address.getAddress().getHostAddress().toString();
                            if (!inDSLITERange(tmp)) {
                                ipAddress = tmp;
                            }
                        }
                    }
                    promise.resolve(ipAddress);
                } catch (Exception e) {
                    promise.resolve(null);
                }

            }
        }).start();
    }


    private Boolean inDSLITERange(String ip) {
        // Fixes issue https://github.com/pusherman/react-native-network-info/issues/43
        // Based on comment https://github.com/pusherman/react-native-network-info/issues/43#issuecomment-358360692
        // added this check in getIPAddress and getIPV4Address
        return RNNetworkInfo.DSLITE_LIST.contains(ip);
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
