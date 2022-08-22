//------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Basic app',
      home: MyHomePage(title: 'GPS / Acceleromter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String now = DateTime.now().toString().substring(0, 19); //the time

  late Position position; //future for positions
  var long = "", lat = ""; //long and lat stored as strings

  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('out of scope'),
      ),
      body: Column(
        children: <Widget>[
          Text('Accelerometer: $accelerometer\n'),
          Text('time: $now\n'),
          Text('longutude: $long\n'),
          Text('latitude: $lat\n')
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    //acceleromter stream
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
            now = DateTime.now().toString().substring(0, 19);
          });
        },
      ),
    );
    //GPS stream
    getLocation();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 50, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    _streamSubscriptions.add(
      Geolocator.getPositionStream(locationSettings: locationSettings)
          // .distinct() //I am not sure if this is needed or not
          .listen((Position position) {
        setState(() {
          long = position.longitude.toString();
          lat = position.latitude.toString();
          //refresh UI on update
        });
      }),
    );
  }
}
