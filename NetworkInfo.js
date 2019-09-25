"use strict";

import { NativeModules, Platform } from "react-native";
const { RNNetworkInfo } = NativeModules;

async function handleError(callback, fallback = null) {
  try {
    return await callback();
  } catch (error) {
    if (__DEV__) console.log(error);

    return fallback;
  }
}

const NetworkInfo = {
  async getSSID(fallback) {
    return await handleError(RNNetworkInfo.getSSID, fallback);
  },

  async getBSSID(fallback) {
    return await handleError(RNNetworkInfo.getBSSID, fallback);
  },

  async getBroadcast(fallback) {
    return await handleError(RNNetworkInfo.getBroadcast, fallback);
  },

  async getIPAddress(fallback) {
    return await handleError(RNNetworkInfo.getIPAddress, fallback);
  },

  async getIPV4Address(fallback) {
    const wifiIP = await handleError(RNNetworkInfo.getWIFIIPV4Address);
    if (wifiIP) {
      return wifiIP;
    }

    return await handleError(RNNetworkInfo.getIPV4Address, fallback);
  },

  async getGatewayIPAddress(fallback) {
    return await handleError(RNNetworkInfo.getGatewayIPAddress, fallback);
  },

  async getSubnet(fallback) {
    return await handleError(RNNetworkInfo.getSubnet, fallback);
  },

  async getFrequency(fallback) {
    if (Platform.OS !== "android") {
      return fallback;
    }
    return await handleError(RNNetworkInfo.getFrequency, fallback);
  },
};

module.exports = { NetworkInfo };
