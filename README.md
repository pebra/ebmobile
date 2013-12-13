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


```
bundle exec middleman build
cordova build
cordova run android
```



### TODOS

### Milestone Store
+ Disable "Auf die Merkliste" Button, when Job is already on the Favorites list
* Uebersetzung, Stylings,
* Autocompletion
* Remove from Merkliste
* Merkliste als E-Mail(??) schicken
* "Teilen" action ausloesbar? also Job durch das Android Share schiken
* 2x nach demselben Suchen cleart Merkliste
