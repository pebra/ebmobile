package com.neton.cordova.diagnostic;
 
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.os.Bundle;
import android.util.Log;
 
/*----------Listener class to get coordinates ------------- */
class MyLocationListener implements LocationListener {
 
    @Override
   public void onLocationChanged(Location loc) {
      
        String longitude = "Longitude: " + loc.getLongitude();
        Log.v("x", longitude);
        String latitude = "Latitude: " + loc.getLatitude();
        Log.v("x", latitude);
               
            try {
        Geocoder gcd = new Geocoder(null, Locale.getDefault());
                  List<Address> addresses = gcd.getFromLocation(loc.getLatitude(), loc.getLongitude(), 1);
              if (addresses.size() > 0)
                  System.out.println(addresses.get(0).getLocality());
 
            } catch (IOException e) {
                  // TODO Auto-generated catch block
                  e.printStackTrace();
            }
    }
 
    @Override
    public void onProviderDisabled(String provider) {}
 
    @Override
    public void onProviderEnabled(String provider) {}
 
    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {}
 
}