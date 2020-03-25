import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';
  bool isPlayingMusic = false;

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _playAudio() async {
    try {
      final bool result = await platform.invokeMethod("playAudio");
      setState(() {
        isPlayingMusic = result;
      });
    } on PlatformException catch (e) {
      print("Failed to play Audio $e");
    }
  }

  Future<void> _pauseAudio() async {
    try {
      final bool result = await platform.invokeMethod("pauseAudio");
      setState(() {
        isPlayingMusic = result;
      });
    } on PlatformException catch (e) {
      print("Failed to play Audio $e");
    }
  }

  Future<void> _stopAudio() async {
    try {
      final bool result = await platform.invokeMethod("stopAudio");
      setState(() {
        isPlayingMusic = result;
      });
    } on PlatformException catch (e) {
      print("Failed to play Audio $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      _stopAudio();
                    },
                    child: Icon(Icons.stop)),
                InkWell(
                    onTap: () {
                      if (isPlayingMusic) {
                        _pauseAudio();
                      } else {
                        _playAudio();
                      }
                    },
                    child:
                    Icon(isPlayingMusic ? Icons.pause : Icons.play_arrow)),
                InkWell(onTap: () {}, child: Icon(Icons.arrow_forward_ios))
              ],
            )
          ],
        ),
      ),
    );
  }
}
