# react-native-network-info

React Native library for getting information about the devices network

## Requirements

Version 3+ requires RN 0.47 or higher
Version 2+ requires RN 0.40 - RN 0.46

## Installation

```javascript
npm install react-native-network-info --save
```

or

```javascript
yarn add react-native-network-info
```

### Linking the library

#### Using React Native >= 0.60

Linking the package manually is not required anymore with Autolinking.

#### `iOS` also requires CocoaPods install

$ cd ios && pod install && cd ..

#### Using React Native >= 0.60

`react-native link react-native-network-info`

## Usage

```javascript
import { NetworkInfo } from "react-native-network-info";

// Get Local IP
NetworkInfo.getIPAddress().then(ipAddress => {
  console.log(ipAddress);
});

// Get IPv4 IP (priority: WiFi first, cellular second)
NetworkInfo.getIPV4Address().then(ipv4Address => {
  console.log(ipv4Address);
});

// Get Broadcast
NetworkInfo.getBroadcast().then(broadcast => {
  console.log(broadcast);
});

// Get SSID
NetworkInfo.getSSID().then(ssid => {
  console.log(ssid);
});

// Get BSSID
NetworkInfo.getBSSID().then(bssid => {
  console.log(bssid);
});

// Get Subnet
NetworkInfo.getSubnet().then(subnet => {
  console.log(subnet);
});

// Get Default Gateway IP
NetworkInfo.getGatewayIPAddress().then(defaultGateway => {
  console.log(defaultGateway);
});

// Get frequency (supported only for Android)
NetworkInfo.getFrequency().then(frequency => {
  console.log(frequency);
});
```

### Manually Linking the Library

If `react-native link` fails and you are not using the auto linking provided in React Native >= 0.60

### `iOS`

1. In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name]

2. Go to node_modules ➜ react-native-network-info and add the .xcodeproj file

3. Add `RNNetworkInfo.a` to `Build Phases -> Link Binary With Libraries`

Run your project (Cmd+R)

### `Android`

1. Add the following lines to `android/settings.gradle`:

   ```gradle
   include ':react-native-network-info'
   project(':react-native-network-info').projectDir = new File(settingsDir, '../node_modules/react-native-network-info/android')
   ```

2. Update the android build tools version to `2.2.+` in `android/build.gradle`:
   ```gradle
   buildscript {
       ...
       dependencies {
           classpath 'com.android.tools.build:gradle:2.2.+' // <- USE 2.2.+ version
       }
       ...
   }
   ...
   ```
3. Update the gradle version to `2.14.1` in `android/gradle/wrapper/gradle-wrapper.properties`:

   ```
   ...
   distributionUrl=https\://services.gradle.org/distributions/gradle-2.14.1-all.zip
   ```

4. Add the compile line to the dependencies in `android/app/build.gradle`:

   ```gradle
   dependencies {
       ...
       compile project(':react-native-network-info')
   }
   ```

5. Add the import and link the package in `MainApplication.java`:

   ```java
   import com.pusherman.networkinfo.RNNetworkInfoPackage; // <-- add this import

   public class MainApplication extends Application implements ReactApplication {
       @Override
       protected List<ReactPackage> getPackages() {
           return Arrays.<ReactPackage>asList(
               new MainReactPackage(),
               new RNNetworkInfoPackage() // <-- add this line
           );
       }
   }
   ```

## Dev Notes

Notes on how this package was made can be [found here](https://eastcodes.com/packaging-and-sharing-react-native-modules "Packaging and Sharing React Native Modules").
