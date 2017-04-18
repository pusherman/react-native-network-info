'use strict';

const { NativeModules } = require('react-native');
const { RNNetworkInfo } = NativeModules;

const NetworkInfo = {
  getSSID(ssid) {
    RNNetworkInfo.getSSID(ssid);
  },

  getIPAddress(ip) {
    RNNetworkInfo.getIPAddress(ip);
  },

  getIPV4Address(ip) {
    RNNetworkInfo.getIPV4Address(ip);
  }
}

module.exports = { NetworkInfo }
