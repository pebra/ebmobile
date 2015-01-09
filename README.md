# Android App for empfehlungsbund.de

## Development

### Install and deploy to phone

This App uses [Apache Cordova](http://cordova.apache.org/).
See the [Cordova Documentation](http://cordova.apache.org/docs/en/3.1.0/) for information about the usage.
You have to install their software to build the app.

To install the other dependencies of the App run

```bash
rake install:brew
rake install:app
```
In order to deploy the app to your android phone run the following commands in the main directory

```bash
rake android:usb
```
### Emulator

You can use the AndroidSDK to debug and test the App, if you want to start the App in the Android emulator run

```bash
rake android:emulator
```

to view the log simply run

```bash
rake debug
```

in the main directory.
## Debug

weinre lets you debug your in mobile chrome

```bash
npm install -g weinre
```

```bash
rake debug:weinre
# uncomment script tag weinre in index.html.haml
# http://192.168.2.125:8080/target/target-script-min.js
make build
cordova run android
# navigate to 192.168.2.125:8080
```

adjust IP of course!

You can also start the App on a web server by running

```bash
rake debug:server
```

## Release

change platforms/android/local.properties

```
#platforms/android/local.properties

sdk.dir=/usr/local/Cellar/android-sdk/23.0.2/

key.store=pludoni-release.keystore
key.alias=pludoni
key.alias.password=.......
key.store.password=.......
```

and run

```bash
rake android:release
```

### Known bug:

### TODOS

### Milestone Store

* Autocompletion - DONE!
* "Teilen" action ausloesbar? also Job durch das Android Share schiken @pebra
  * Merkliste als E-Mail(??) schicken - DONE
* Buildskript: Pfade!!! /js -> js @zealot128 DONE!
* Lade-Indikator - DONE
* Notification/ gemerkt etc
* Geolocation - DONE
