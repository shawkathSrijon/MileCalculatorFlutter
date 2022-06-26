import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mile_calculator/user_location.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class MileCalculationBrain extends ChangeNotifier {
  Location location = new Location();
  List<UserLocation> userLocations = [];
  UserLocation? startingLocation;
  UserLocation? endLocation;

  UserLocation? _currentLocation;
  double totalDistance = 0;
  int timeOfNoMovement = 0;

  // Continuous update of user location
  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();
  Stream<UserLocation> get locationStream => _locationController.stream;

  MileCalculationBrain() {
    location.requestPermission().then((granted) {
      if(granted != false) {
        location.onLocationChanged.listen((locationData) {
          print(locationData);
          if (locationData != null) {
            _locationController.add(UserLocation(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0, locationData.speed ?? 0.0));
            userLocations.add(UserLocation(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0, locationData.speed ?? 0.0));


            final periodicTimer = Timer.periodic(
              const Duration(seconds: 15),
                  (timer) {
                      if ((locationData.speed ?? 0.0) < 2.0) {
                        timeOfNoMovement += 15;
                      } else {
                        timeOfNoMovement = 0;
                      }

                     if ((timeOfNoMovement >= 300) && (userLocations.length >= 10)) {
                       if (startingLocation == null) {
                         startingLocation = userLocations.first;
                         //TODO: Make API call here to send starting position to server.
                       }
                       endLocation = userLocations.last;

                       for(var i = 0; i < userLocations.length-1; i++){
                         totalDistance += calculateDistance(userLocations[i].latitude, userLocations[i].longitude, userLocations[i+1].latitude, userLocations[i+1].longitude);
                         print(totalDistance.toString());
                       }
                       //TODO: Make API call here to send ending position to server.
                       //TODO: Make API call here to send total distance to server.
                       userLocations.clear();
                       timer.cancel();
                     }
                  },
            );

            if ((userLocations.length ?? 0) >= 500) {
              startingLocation = userLocations.first;
              //TODO: Make API call here to send starting position to server.

              for(var i = 0; i < userLocations.length-1; i++){
                totalDistance += calculateDistance(userLocations[i].latitude, userLocations[i].longitude, userLocations[i+1].latitude, userLocations[i+1].longitude);
                print(totalDistance.toString());
              }
              userLocations.clear();
            }
          }
        });
      }
    });
  }

  // For user's current location
  Future<UserLocation?> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(userLocation.latitude ?? 0.0, userLocation.longitude ?? 0.0, userLocation.speed ?? 0.0);
    } catch(e) {
      print('Could not get user location: $e');
    }

    return _currentLocation;
  }

  // Distance calculation
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}