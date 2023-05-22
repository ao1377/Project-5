import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(TennisRacketApp());

class TennisRacketApp extends StatefulWidget {
  @override
  _TennisRacketAppState createState() => _TennisRacketAppState();
}

class _TennisRacketAppState extends State<TennisRacketApp> {
  double mass = 0.2; // Mass of the phone (you can set a default value)
  List<double> lastAccelerometerData = [0, 0, 0];
  List<double> lastGyroscopeData = [0, 0, 0];
  bool isSwinging = false;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        lastAccelerometerData = [event.x, event.y, event.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        lastGyroscopeData = [event.x, event.y, event.z];
      });
    });
  }

  double calculateForce() {
    double accelerationX = lastAccelerometerData[0];
    double accelerationY = lastAccelerometerData[1];
    double accelerationZ = lastAccelerometerData[2];
    return (mass * (accelerationX * accelerationX +
            accelerationY * accelerationY +
            accelerationZ * accelerationZ))
        .sqrt();
  }

  double calculateRotationAngle() {
    double rotationX = lastGyroscopeData[0];
    double rotationY = lastGyroscopeData[1];
    double rotationZ = lastGyroscopeData[2];
    return (rotationX * rotationX + rotationY * rotationY + rotationZ * rotationZ).sqrt();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tennis Racket'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Force:',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                isSwinging ? calculateForce().toStringAsFixed(2) : '0.00',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Text(
                'Rotation Angle:',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                isSwinging ? calculateRotationAngle().toStringAsFixed(2) : '0.00',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isSwinging = !isSwinging;
            });
          },
          child: Icon(isSwinging ? Icons.sports_tennis : Icons.play_arrow),
        ),
      ),
    );
  }
}