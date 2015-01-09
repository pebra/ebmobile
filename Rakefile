SDK_LOCATIONS = [
  ENV["HOME"] + '/ADT-SDK/sdk/',
  '/Applications/adt-bundle/sdk',
  '/usr/local/Cellar/android-sdk/23.0.2/',
  '/usr/local/Cellar/android-sdk/24.0.1/'
]

def find_java_home
  SDK_LOCATIONS.find{|f| File.exists? f }
end

namespace :build do
  desc 'Ratched Style Android'
  task :prepare_android do
    sh "
      sed -i -E 's/ratchet\-theme\-ios\.min\.css/ratchet-theme-android\.min\.css/' ebapp/source/css/all.css
    "
  end

  desc 'Ratched Style iOS'
  task :prepare_ios do
    sh "
      sed -i -E 's/ratchet\-theme\-android\.min\.css/ratchet\-theme\-ios\.min\.css/' ebapp/source/css/all.css
    "
  end

  desc 'Start Middleman auf Port 3500'
  task :server do
    sh '
      cd ebapp/source && bundle exec middleman server -p 3500
    '
  end

  desc 'Middleman build'
  task :development => ['android:set_env'] do
    sh '
      cd ./ebapp
      bundle exec middleman build
    '
  end
end

namespace :debug do
  desc 'Logcat aufs Primaere Android Device'
  task :logcat do
    sh '
    adb logcat CordovaLog:D chromium:D *:S
    '
  end

  desc 'Start Weinre auf Port 8080'
  task :weinre do
    sh 'weinre --boundHost 0.0.0.0'
  end

  desc 'Server auf port 3500'
  task :server do
    sh 'cd ebapp &&  bundle exec middleman server -p 3500'
  end
end

namespace :android do

  task :build => [:set_env, 'build:prepare_android', 'build:development']  do
    sh ' cordova build android '
  end

  task :set_production do
    ENV['BUILD_ENV'] = 'production'
    mkdir_p 'releases'
  end

  desc 'Bauen + Auf angeschlossenem Device starten'
  task :usb => [:build] do
    sh ' cordova run android '
  end

  desc 'Bauen + Emulator starten'
  task :emulator => [:build] do
    sh ' cordova run --emulator android '
  end

  desc 'Release einer neuen Version'
  task :release => [:set_production, :build] do
    sh '
      cd platforms/android/ && ant release
      mv platforms/android/bin/Empfehlungsbund-release.apk releases/empfehlungsbund-`date +%Y-%m-%d`.apk
    '

  end

  task :set_env do
    sdk = find_java_home
    if !sdk
      raise 'Android SDK nich gefunden, habe gesucht in: ' + SDK_LOCATIONS.join("\n")
    end
    require 'pry'
    ENV['ANDROID_HOME'] = sdk
    ENV['PATH'] = ENV['PATH'] + ":#{ENV['ANDROID_HOME']}/tools:#{ENV['ANDROID_HOME']}/platform-tools"
  end
end


namespace :install do
  desc 'install all dependencies besides the ones from install:app'
  task :brew do
    sh '
  brew install java
  brew install ant
  brew install android-sdk
  brew install node
  npm install -g cordova bower
    '
  end

  desc 'install middleman + bower abh.'
  task :app do
    sh '
	cd ebapp/
	bundle
	bower install
  '

  end

  desc 'initialize cordova'
  task :cordova do
    sh '
    cordova platform add android
    android update project -p platforms/android
    '
  end
end
