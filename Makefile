app:
	cordova build
	cordova run android

install:
	npm install karma --save-dev
	npm install karma-qunit --save-dev
	npm install karma-ember-preprocessor --save-dev

init:
	cordova platform add android
	android update project -p platforms/android
	cd ebapp/ && bower install
	echo 'MAKE SURE LEAFLET IS COMPILED!!!!!!!!'

server:
	cd ebapp/source && middleman server -p 3506

test:
	cd ebapp/ && bundle exec rspec

fulltest:
	cd ebapp/source &&  bundle exec middleman server -p 3506 &
	sleep 4
	cd ebapp/ && bundle exec rspec
	pgrep -f middleman | xargs kill

build:
	cd ebapp/ && bundle exec middleman build
	rm -rf www/ignore/
	rm -rf www/spec/
	cordova prepare
	cordova build
	cordova run android


release:
	mkdir -p releases
	cd platforms/android/ && ant release
	mv platforms/android/bin/Empfehlungsbund-release.apk releases/empfehlungsbund-`date +%Y-%m-%d`.apk

