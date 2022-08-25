import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class getSensors {
  //this function takes the acceleromtr event as arg
  //returns [x values, y values, z values, time]
  List getAccell(AccelerometerEvent event) {
    var now = DateTime.now().toString();
    var accelValues = [event.x, event.y, event.z, now];
    return accelValues;
  }

  //takes in a position event, return [latitude,longitude, time]
  List getGPS(Position position) {
    var now = DateTime.now().toString();
    var gpsValues = [
      position.latitude.toString(),
      position.longitude.toString(),
      now
    ];
    return gpsValues;
  }
}


//swag 