import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _timeLeft = '25:00';
  int _pomodoroTime = 25 * 60;
  int _restTime = 5 * 60;
  int _seconds = 25 * 60;
  bool _timerStarted = false;
  bool _resting = false;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _timerStarted = true;
    });

    // SystemSound.play(SystemSoundType.click);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _refreshTimer();
    });
  }

  void _stopTimer() {
    setState(() {
      _timer!.cancel();
      _timerStarted = false;
      _resting = false;
      _seconds = _pomodoroTime;
      _timeLeft = parseTime(_seconds);
    });
  }

  void _refreshTimer() {
    setState(() {
      _seconds--;

      if(_seconds != 0) {
        _timeLeft = parseTime(_seconds);

      } else if(!_resting) {
        // start rest period
        // SystemSound.play(SystemSoundType.click);
        _seconds = _restTime;
        _resting = true;
        _timeLeft = parseTime(_seconds);

      } else if(_resting) {
        // start new pomodoro
        // SystemSound.play(SystemSoundType.click);
        _seconds = _pomodoroTime;
        _resting = false;
        _timeLeft = parseTime(_seconds);

      }
    });
  }

  String parseTime(int seconds) {
    int minutes = (_seconds % (60 * 60)) ~/ 60;
    int seconds = (_seconds % (60 * 60)) % 60;
    return "${minutes != 0 ? minutes : '00'}:${seconds != 0 ? seconds : '00'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                _timeLeft,
                style: const TextStyle(
                  fontSize: 72.0
                ),
              ),
            ),
            _getIconButton(),
          ],
        ),
      ),
    );
  }

  Widget _getIconButton() {
    
    if (_timerStarted && !_resting) {

      return Material(
        color: Colors.white,
        child: Center(
          child: Ink(
            width: 160.0,
            height: 160.0,
            decoration: const ShapeDecoration(
              color: Colors.lightBlue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 72,
              icon: const Icon(Icons.square),
              color: Colors.white,
              onPressed: _stopTimer,
              tooltip: 'Stop',
            ),
          ),
        ),
      );

    } else if(_timerStarted && _resting) {

      return Material(
        color: Colors.white,
        child: Center(
          child: Ink(
            width: 160.0,
            height: 160.0,
            decoration: const ShapeDecoration(
              color: Colors.greenAccent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 72,
              icon: const Icon(Icons.square),
              color: Colors.white,
              onPressed: _stopTimer,
              tooltip: 'Stop',
            ),
          ),
        ),
      );

    } else {

      return Material(
        color: Colors.white,
        child: Center(
          child: Ink(
            width: 160.0,
            height: 160.0,
            decoration: const ShapeDecoration(
              color: Colors.lightBlue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              iconSize: 88,
              icon: const Icon(Icons.play_arrow),
              color: Colors.white,
              onPressed: _startTimer,
              tooltip: 'Start',
            ),
          ),
        ),
      );
    }
  }
}
