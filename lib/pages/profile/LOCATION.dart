import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:single_ecommerce/common%20class/engString.dart';

class locationpermission {
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<LocationData?> currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = new  Location();
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData _locationdata = await location.getLocation();
    print(_locationdata.latitude);
    print(_locationdata.longitude);
    double longitude = _locationdata.longitude ?? 00.0;
    double latitude = _locationdata.latitude ?? 00.0;
    Engstring.longitude = _locationdata.longitude ?? 00.0;
    Engstring.latitude = _locationdata.latitude ?? 00.0;
    LatLng currentLatLng = new LatLng(latitude, longitude);
    return await location.getLocation();
  }
}
