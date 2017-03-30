# react-native-network-info

React Native library for getting information about the devices network

## Usage

First you need to install react-native-network-info:

```javascript
npm install react-native-network-info --save
```

### `iOS`

In XCode, in the project navigator, right click Libraries ➜ Add Files to [your project's name] Go to node_modules ➜ react-native-network-info and add the .xcodeproj file

In XCode, in the project navigator, select your project. Add the lib*.a from the network-info project to your project's Build Phases ➜ Link Binary With Libraries Click .xcodeproj file you added before in the project navigator and go the Build Settings tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for Header Search Paths and make sure it contains both $(SRCROOT)/../../react-native/React and $(SRCROOT)/../../React - mark both as recursive.

Run your project (Cmd+R)

### `Android`

* `android/settings.gradle`

```gradle
...
include ':react-native-network-info'
project(':react-native-network-info').projectDir = new File(settingsDir, '../node_modules/react-native-network-info/android')
```
* `android/app/build.gradle`

```gradle
dependencies {
	...
	compile project(':react-native-network-info')
}
```

* register module (in MainApplication.java)

```java
...

import com.pusherman.networkinfo.RNNetworkInfoPackage; // <--- IMPORT

public class MainActivity extends Activity implements DefaultHardwareBackBtnHandler {
	...

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
              new MainReactPackage(),
              ...
              new RNNetworkInfoPackage(),	<=== ADD HERE
	      ...
      );
    }
  };
```

## Examples

```javascript

// require module
var NetworkInfo = require('react-native-network-info');

// Get SSID
NetworkInfo.getSSID(ssid => {
  console.log(ssid);
});

// Get Local IP
NetworkInfo.getIPAddress(ip => {
  console.log(ip);
});

```

## Dev Notes
Notes on how this package was made can be [found here](http://eastcodes.com/packaging-and-sharing-react-native-modules "Packaging and Sharing React Native Modules").


