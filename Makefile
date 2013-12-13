app:
	cordova build
	cordova run android

install:
	npm install karma --save-dev
	npm install karma-qunit --save-dev
	npm install karma-ember-preprocessor --save-dev

server:
	cd ebapp/source && middleman server -p 3506

test:
	cd ebapp/ && bundle exec rspec

fulltest:
	cd ebapp/source && middleman server -p 3506 &
	sleep 4
	cd ebapp/ && bundle exec rspec
	pgrep -f middleman | xargs kill
