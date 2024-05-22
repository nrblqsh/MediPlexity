import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';

void main() {
  runApp(const Heartrate());
}

class Heartrate extends StatelessWidget {
  const Heartrate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SensorValue> data = [];
  int? bpmValue;
  bool _measuring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cover both the camera and flash with your finger",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _startMeasuring,
              child: Text('Start Countdown'),
            ),
            const SizedBox(height: 22),
            if (_measuring)
              Text(
                'Measuring...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (bpmValue != null && !_measuring)
              Text(
                'Result: $bpmValue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _startMeasuring() {
    setState(() {
      _measuring = true;
      bpmValue = null; // Reset previous result
    });

    // Wait for 30 seconds to simulate measuring process
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        _measuring = false; // Stop measuring
        bpmValue = 75; // Example result (replace with actual measurement)
      });
    });
  }
}
