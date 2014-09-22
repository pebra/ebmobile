app:
	cordova build
	cordova run android


prereq_osx:
	brew install java
	brew install ant
	brew install android-sdk
	brew install node
	npm install -g cordova bower

install:
	cd ebapp/
	bundle
	bower install

init:
	cordova platform add android
	android update project -p platforms/android

server:
	cd ebapp/source && middleman server -p 3506

test:
	cd ebapp/ && bundle exec rspec

test_prereq:
	npm install karma --save-dev
	npm install karma-qunit --save-dev
	npm install karma-ember-preprocessor --save-dev

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

prepare_ios:
	sed -i -E 's/ratchet\-theme\-android\.min\.css/ratchet\-theme\-ios\.min\.css/' ebapp/source/css/all.css

build_ios: prepare_ios build

prepare_android:
	sed -i -E 's/ratchet\-theme\-ios\.min\.css/ratchet-theme-android\.min\.css/' ebapp/source/css/all.css

build_android: prepare_android build

deploy:
	cordova run android

deploy_android: prepare_android build deploy

release:
	cd ebapp/ && bundle exec middleman build
	mkdir -p releases
	cordova prepare && cordova compile
	cd platforms/android/ && ant release
	mv platforms/android/bin/Empfehlungsbund-release.apk releases/empfehlungsbund-`date +%Y-%m-%d`.apk

