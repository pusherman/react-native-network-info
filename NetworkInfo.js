"use strict";

import { NativeModules, Platform } from "react-native";
const { RNNetworkInfo } = NativeModules;

const NetworkInfo = {
  async getSSID() {
    return await RNNetworkInfo.getSSID();
  },

  async getBSSID() {
    return await RNNetworkInfo.getBSSID();
  },

  async getBroadcast() {
    return await RNNetworkInfo.getBroadcast();
  },

  async getIPAddress() {
    return await RNNetworkInfo.getIPAddress();
  },

  async getIPV4Address() {
    let wifiIP = await RNNetworkInfo.getWIFIIPV4Address();
    if (wifiIP && wifiIP != '0.0.0.0') {
      return wifiIP;
    } else {
      return await RNNetworkInfo.getIPV4Address();
    }
  },

  async getGatewayIPAddress() {
    return await RNNetworkInfo.getGatewayIPAddress();
  },

  async getSubnet() {
    return await RNNetworkInfo.getSubnet();
  },

  async getFrequency() {
    if (Platform.OS !== 'android') {
      return null;
    }
    return await RNNetworkInfo.getFrequency();
  }
};

module.exports = { NetworkInfo };
