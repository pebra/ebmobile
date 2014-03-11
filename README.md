# Android App for empfehlungsbund.de

## Development

Developing on the webapp:

```bash
cd ebapp/
bundle
bundle exec middleman server -p$PORT

```

This App uses [Apache Cordova](http://cordova.apache.org/).
See the [Cordova Documentation](http://cordova.apache.org/docs/en/3.1.0/) for information about the usage.
You have to install their software to build the app.

In order to deploy the app to your android phone run


```bash
bundle exec middleman build
cordova build
cordova run android
```

## Debug

weinre let you debug your in mobile chrome

```bash
npm install -g weinre
```

```bash
weinre --boundHost 192.168.2.102
# uncomment script tag weinre in index.html.haml
make build
cordova run android
# navigate to 192.168.2.102:8080
```

adjust IP of course!

### Known bug:
When running middleman build the built index.html contains wrong links to all.css and all.js. The leading "/" hast to be removed. "/css/all.css" => "/css/all.css"

### TODOS

### Milestone Store

* Autocompletion
* "Teilen" action ausloesbar? also Job durch das Android Share schiken @pebra
  * Merkliste als E-Mail(??) schicken
* Buildskript: Pfade!!! /js -> js @zealot128
* Lade-Indikator
* Notification/ gemerkt etc
* Geolocation



