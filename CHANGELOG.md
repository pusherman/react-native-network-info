## 5.2.1 - 2019-09-23 (Yellow Check)

### Bug Fix
- (iOS) Fixed iOS compile error when auto linking (thanks @zusinShinpei)

## 5.2.0 - 2019-09-23 (Yellow Mark)

- (iOS/Android) Added getGatewayIPAddress method (thanks @parrotmac)
- (iOS/Android) Updated getIPV4Address to return WIFI IP if connected (thanks @Rapsssito)
- (Android) Added getFrequency to get wifi frequency (thanks @antonkulyk)

## 5.1.0 - 2019-06-24 (The Upside Down)

- (iOS/Android) Added getSubnet method (thanks @richardvclam)
- (iOS) Added support for tvOS (thanks @richardvclam & @ChrisOdicho)

## 5.0.1 - 2019-05-25 (Teensy Weensy)

### Bug Fix
- (Android) Removed unused Android import (thanks @GuillermoRivera & @MaShizhen)

## 5.0.0 - 2019-05-25 (Itsy Bitsy)

### Breaking Changes
- (iOS/Android) Switched from callbacks to async methods (thanks @hosseinmd)
- (Android) Migrated to AndroidX (thanks @rafcontreras)

### Bug Fix
- (Android) Updated dependency configurations for Android (thanks @robwalkerco)
- (npm) Removed android/build from npm package to reduce size


## 4.0.1 - 2019-01-09 (Traveling On)

### Bug Fix
- (Android) Fix intellij-core (thanks @martinffx)
- (Android) Ignore DS-LITE block of ip addresses (thanks @shashfrankenstien)
- (iOS) Corrected import module (thanks @wuwen2333)


## 4.0.0 - 2018-09-04 (Walrus Tooth)

### Breaking Changes
- (Android) The string "error" will be returned if the library is unable to find the value requested
to keep it consistent with the iOS library

### Features
- (Android) SupplicantState is now checked to fix a bug when wifi was turned off then back on (thanks @yosimasu)
- Typescript declarations added (thanks @fitzpasd)


## 3.2.2 - 2018-04-06 (Desert Wine)

### Bug Fix
- (Android) Removed createJSModules to fix Android build


## 3.2.1 - 2018-04-04 (Refined Wine)

### Bug Fix
- (Android) Added google as a repo to build.gradle


## 3.2.0 - 2018-04-03 (Fine Wine)

### Features
- (iOS/Android) Added method for getting broadcast address (thanks @codlab)
- (Android) Upgrade library dependencies (thanks @codlab)


## 3.1.0 - 2018-03-06 (Catnip)

### Features
- (iOS) Added support for getting IPv4 address (thanks @jgfidelis)


## 3.0.0 - 2017-08-07 (Flapjack)

### Breaking Changes
- Updated to support React Native 0.47


## 2.2.0 - 2017-05-23 (Juggernaut)

### Features
- (Android) Added method for getting IPv4 address (thanks @davidstoneham)


## 2.1.0 - 2017-04-28 (City Slicker)

### Features
- Added method for getting BSSID


## 2.0.0 - 2017-04-07 (Saki Bomb)

### Breaking Changes
- (JS) Switched to named exports

`var NetworkInfo = require('react-native-network-info');`

becomes

`import { NetworkInfo } from 'react-native-network-info';`;

### Fixes
- (Android) Switched to getApplicationContext() to prevent possible memory leaks
- (Android) Updated getIPAddress so IP will be shown in the simulator

### Features
- Updated README to make the Installation instructions up to date


## 1.0.0 - 2017-03-17 (Ghostwriter)

### Breaking Changes
- Updated to support React Native 0.40.0


## 0.2.0 - 2015-11-21 (Pepperjack)

### Breaking Changes
- Updated to support React Native 0.14.2

### Features
- Added podspec support


## 0.1.1 - 2015-07-12 (Bees Knees)

### Features
- Updated README to include installation instructions


## 0.1.0 - 2015-07-12 (Lemurparty)

### Features
- Support for getting IP and SSID for Android and iOS
