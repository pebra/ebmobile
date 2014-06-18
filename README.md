#Android App for empfehlungsbund.de
    
##Prerequisites

Before you can start developing on the webapp you need to download some extra files and move them into the ebapp/source/css/ and ebapp/source/js/ directory.      
The Files you need are listed below:
###css:

* [Leaflet](http://leafletjs.com/download.html)   
* [Ratchet](http://goratchet.com/)


Note: The exact path for these files is specified in all.css which can be found in    
ebapp/source/css/.      

###js:

* Leaflet
* Ratchet
* [jQuery](http://jquery.com/download/)(compressed production jQuery) 
* [jQuery throttle](http://benalman.com/projects/jquery-throttle-debounce-plugin/)(must be renamed) 
* [angular.js, angular-route.js, angular-resource.js, angular-cookies.js](https://angularjs.org/)
* [angularLocalStorage](https://github.com/grevory/angular-local-storage)
* [angulartics](http://luisfarzati.github.io/angulartics/)


Note: The exact path for these files is specified in all.js which can be found in    
ebapp/source/js/.  

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
bundle exec middleman build #run this in the ebapp folder
cordova build #run this from the project root
cordova run android #aswell as this
```

## Debug

weinre lets you debug your in mobile chrome

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

### TODOS

### Milestone Store

* Autocompletion - DONE!
* "Teilen" action ausloesbar? also Job durch das Android Share schiken @pebra
  * Merkliste als E-Mail(??) schicken - DONE
* Buildskript: Pfade!!! /js -> js @zealot128 DONE!
* Lade-Indikator - DONE
* Notification/ gemerkt etc
* Geolocation - DONE


