'use strict';

import { NativeModules } from 'react-native';
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
    return await handleError(RNNetworkInfo.getIPV4Address, fallback);
  },
};

module.exports = { NetworkInfo };
