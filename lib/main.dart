//------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'file_io.dart';

//Threading constants
final gps_delay = Duration(seconds: 3);
final accel_delay = Duration(seconds: 3);
final toStage_delay = Duration(seconds: 30);
final toUpload_delay = Duration(seconds: 30);
final upload_delay = Duration(seconds: 60);

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
  var toggle = 0; //toggle 0:on 1:off

  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void _setToggle(var value) {
    setState(() {
      toggle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: const Text('out of scope'),
      ),
      body: Column(
        children: <Widget>[
          Text('Accelerometer: $accelerometer\n'),
          Text('time: $now\n'),
          Text('longutude: $long\n'),
          Text('latitude: $lat\n'),
          ElevatedButton(
            style: style,
            onPressed: () {
              _setToggle(1);
            },
            child: const Text('First Button'),
          ),
          ElevatedButton(
            style: style,
            onPressed: () {
              _setToggle(0);
            },
            child: const Text('Second Button'),
          ),
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

  //Threading
  //GPS Thread
  Future<void> gpsThread() async {
    //add gps retrieval and save to file here
  }

  //Accelerometer Thread
  Future<void> accelThread() async {
    //add accelerometer retrieval and save to file here
  }

  //Moving file from writing to staging
  Future<void> toStageThread() async {
    //add writing to staging code here
  }

  //Moving file from staging to upload
  Future<void> toUploadThread() async {
    //add staging to upload code here
  }

  //upload file to database
  Future<void> uploadThread() async {
    //add upload code here
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

    //Thread timer
    Timer.periodic(gps_delay, (Timer gpsTimer) {
      gpsThread();
    });

    Timer.periodic(accel_delay, (Timer accelTimer) {
      accelThread();
    });

    Timer.periodic(toStage_delay, (Timer toStageTimer) {
      toStageThread();
    });

    Timer.periodic(toUpload_delay, (Timer toUploadTimer) {
      toUploadThread();
    });

    Timer.periodic(upload_delay, (Timer uploadTimer) {
      uploadThread();
    });
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
