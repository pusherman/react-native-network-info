'use strict';

var RNNetworkInfo = require('NativeModules').RNNetworkInfo;

var NetworkInfo = {
  getSSID(ssid) {
    RNNetworkInfo.getSSID(ssid);
  },

  getIPAddress(ip) {
    RNNetworkInfo.getIPAddress(ip);
  }
};

module.exports = NetworkInfo;
