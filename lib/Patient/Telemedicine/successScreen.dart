import 'package:flutter/material.dart';
import 'package:fyp/Patient/Telemedicine/viewUpcomingAppointmentforPatientSide.dart';
import 'package:fyp/main.dart';

import '../patientHomePage.dart';


class SuccessRequestScreen extends StatefulWidget {
  final int specialistID;
  final int patientID;
  final String textButton;
  const SuccessRequestScreen({
    required this.specialistID,
  required this.patientID,
    required this.textButton
  });

  @override
  State<SuccessRequestScreen> createState() => _SuccessRequestState();
}


class _SuccessRequestState extends State<SuccessRequestScreen> {


  late int specialistID;
  late int patientID;
  late String textbutton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void>loadData() async{

    super.initState();
    specialistID = widget.specialistID;
    patientID = widget.patientID;
    textbutton = widget.textButton;

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, top: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/done1.png',
                          width: 120,
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: SizedBox(width: 10),
                      ),
                      Text(
                        "Request successfully sent!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(textbutton == "Upcoming Appointment")
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                   ViewUpcomingAppointmentforPatientSide(
                                       patientID:int.parse(patientID.toString()))
                              ));

                        }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                      ),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'View on ${textbutton} Page',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}