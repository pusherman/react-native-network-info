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
