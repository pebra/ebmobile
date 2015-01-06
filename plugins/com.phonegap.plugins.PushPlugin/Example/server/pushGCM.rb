require 'rubygems'
require 'pushmeup'
GCM.host = 'https://android.googleapis.com/gcm/send'
GCM.format = :json
GCM.key = "AIzaSyBY0zrxcstLAFexnaVj2vYyQw05SBXrP8E"
destination = ["APA91bG7TGaYShfb_w0k0WC6WaURqrtOrM_D6l7Wn0zvsn_hLTf7VCPnZtV30xTHovkZLeBrokUh1k0_GrneqlKk1385clOJdp4po1vkhwr5uPoerLyTuFWjMoZjYcJaDK8k4YUIkZpIr1npSLQKWlytnhaRTTKorcECzzWVqidyGslAmz3NorE
"]
data = {:message => "PhoneGap Build rocks!", :msgcnt => "1", :soundname => "beep.wav"}

GCM.send_notification( destination, data)
