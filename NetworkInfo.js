'use strict';

import { NativeModules } from 'react-native';
const { RNNetworkInfo } = NativeModules;

const NetworkInfo = {
  getSSID(ssid) {
    RNNetworkInfo.getSSID(ssid);
  },

  getBSSID(bssid) {
    RNNetworkInfo.getBSSID(bssid);
  },

  getBroadcast(ip) {
    RNNetworkInfo.getBroadcast(ip);
  },

  getIPAddress(ip) {
    RNNetworkInfo.getIPAddress(ip);
  },

  getIPV4Address(ip) {
    RNNetworkInfo.getIPV4Address(ip);
  }
}

module.exports = { NetworkInfo }
