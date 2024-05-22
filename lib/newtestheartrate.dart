import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HomePagehear extends StatefulWidget {
  final int patientID;

  HomePagehear({
    required this.patientID,
  });

  @override
  State<HomePagehear> createState() => _HomePageState();
}

class _HomePageState extends State<HomePagehear> {
  late int patientID;
  int? measurementResult;


  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isBPMEnabled = false;
  Widget? dialog;
  int countdown = 30; // Countdown in seconds
  late Timer? timer;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    patientID = widget.patientID;
    print("patient id is $patientID");
  }

  @override
  void dispose() {
    timer?.cancel(); // Dispose the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer?.cancel();
          isBPMEnabled = false; // Stop measurement when countdown finishes
          // Calculate the measurement result
          if (bpmValues.isNotEmpty) {
            int sum = 0;
            for (var value in bpmValues) {
              sum += value.value.toInt();
            }
            measurementResult = sum ~/ bpmValues.length; // Calculate average
          } else {
            measurementResult = null; // No measurement result if no data
          }
          // Display the result in a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Measurement Result'),
              content: measurementResult != null
                  ? Text('Heart Rate: $measurementResult bpm')
                  : Text('No measurement result'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      });
    });
  }


  void toggleMeasurement() {
    setState(() {
      if (isBPMEnabled) {
        isBPMEnabled = false;
        timer?.cancel();
      } else {
        isBPMEnabled = true;
        countdown = 30; // Set countdown to 30 seconds
        startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Heart BPM Demo'),
      ),
      body: Column(
        children: [
          isBPMEnabled
              ? dialog = HeartBPMDialog(
            context: context,
            showTextValues: true,
            borderRadius: 10,
            onRawData: (value) {
              setState(() {
                if (data.length >= 100) data.removeAt(0);
                data.add(value);
              });
            },
            onBPM: (value) => setState(() {
              if (bpmValues.length >= 100) bpmValues.removeAt(0);
              bpmValues.add(
                  SensorValue(value: value.toDouble(), time: DateTime.now()));
              if (countdown <= 0) {
                isBPMEnabled = false;
                timer?.cancel();
                // Set the heart rate measurement result
                measurementResult = value;
                // Display the result in a dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Measurement Result'),
                    content: Text('Heart Rate: $measurementResult bpm'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            }),

          )
              : SizedBox(),
          isBPMEnabled && data.isNotEmpty
              ? Container(
            decoration: BoxDecoration(border: Border.all()),
            height: 180,
            child: BPMChart(data),
          )
              : SizedBox(),
          isBPMEnabled && bpmValues.isNotEmpty
              ? Container(
            decoration: BoxDecoration(border: Border.all()),
            constraints: BoxConstraints.expand(height: 180),
            child: BPMChart(bpmValues),
          )
              : SizedBox(),
          Center(
            child: ElevatedButton.icon(
              icon: Icon(Icons.favorite_rounded),
              label:
              Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
              onPressed: toggleMeasurement,
            ),
          ),
          Text(
            'Countdown: $countdown seconds',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
