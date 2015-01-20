App.factory "Device", ($rootScope)->
  {
    isAndroid:  ->
      device? and ( device.platform == "android" || device.platform == "Android")
  }
