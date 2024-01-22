import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stretch Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 5, 49, 100)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stretch Timer'),
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
  int _stretchCounter = 30;
  int _restCounter = 5;
  int _displayCounter = 0;
  bool isStretching = true;
  late Timer _timer;

  void _playBeepSound() async {
    final player = AudioPlayer();
    //await player.setSource(AssetSource('beepMP3.mp3'));
    player.play(AssetSource('beepMP3.mp3'));
  }

  void _playBoopSound() async {
    final player = AudioPlayer();
    //await player.setSource(AssetSource('boopMP3.mp3'));
    player.play(AssetSource('boopMP3.mp3'));
  }

  void _startTimer() {
    if (isStretching) {
      _displayCounter = _restCounter;
    } else {
      _displayCounter = _stretchCounter;
    }
    _timerCountdown();
  }

  void _timerCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_displayCounter >= 0) {
        _incrementCounter();
        if (_displayCounter == 3 ||
            _displayCounter == 2 ||
            _displayCounter == 1) {
          _playBeepSound();
          print('BEEP');
        }
        if (_displayCounter <= 0) {
          _playBoopSound();
          print('BOOP');
          isStretching = !isStretching;
          _timer.cancel();
          _startTimer();
        }
        //print('The value of the counter is: $_displayCounter');
      } else {
        _timer.cancel();
      }
    });
  }

  void _resetTimer() {
    _timer.cancel();
    isStretching = true;
    setState(() {
      _displayCounter = 0;
    });
  }

  void _incrementCounter() {
    setState(() {
      _displayCounter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Stretch Timer',
          style: Theme.of(context).textTheme.headlineMedium!,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    '$_displayCounter',
                    style: TextStyle(
                      fontSize: 222,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' Rest Time',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(1, 0),
                    child: Slider(
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Colors.white,
                      min: 0,
                      max: 20,
                      value: _restCounter.toDouble(),
                      onChanged: (newValue) {
                        newValue = double.parse(newValue.toStringAsFixed(2));
                        setState(() => _restCounter = newValue.toInt());
                      },
                    ),
                  ),
                  Text(
                    '$_restCounter ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ' Stretch Time',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Slider(
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.white,
                    min: 10,
                    max: 60,
                    value: _stretchCounter.toDouble(),
                    onChanged: (newValue) {
                      newValue = double.parse(newValue.toStringAsFixed(2));
                      setState(() => _stretchCounter = newValue.toInt());
                    },
                  ),
                  Text(
                    '$_stretchCounter ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 120, // Adjust the width to make the button larger
                      height:
                          120, // Adjust the height to make the button larger
                      child: FloatingActionButton(
                        onPressed: _startTimer,
                        tooltip: 'Start Timer',
                        child: const Icon(
                          Icons.play_arrow,
                          size: 45, // Adjust the size of the icon
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: 120, // Adjust the width to make the button larger
                      height:
                          120, // Adjust the height to make the button larger
                      child: FloatingActionButton(
                        onPressed: _resetTimer,
                        tooltip: 'Reset Timer',
                        child: const Icon(
                          Icons.stop,
                          size: 45, // Adjust the size of the icon
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
