import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Model/consultation.dart';
import '../../../Model/medication.dart';

class SpecificConsultationDetails extends StatefulWidget {
  final int consultationID;
  final int patientID;
  final String patientName;
  final String phone;

  SpecificConsultationDetails({
    required this.consultationID,
    required this.patientID,
    required this.patientName,
    required this.phone,
  });

  @override
  _SpecificConsultationDetailsState createState() => _SpecificConsultationDetailsState();
}

class _SpecificConsultationDetailsState extends State<SpecificConsultationDetails> {
  Consultation? consultation;
  late int storedConsultID;
  late int consultationID;
  late int patientID;
  late String patientName;
  late String phone;
  late int specialistID = 0;
  late String specialistName;
  late String logStatus;
  DateTime consultationDateTime = DateTime.now();
  int medID = 0;
  int medicationID = 0;
  String consultationStatus = '';
  String consultationSymptom = '';
  String consultationTreatment = '';
  String medGeneral = '';
  String medForm = '';
  String dosage = '';
  String medInstruction = '';

  @override
  void initState() {
    super.initState();
    consultationID = widget.consultationID;
    patientName = widget.patientName;
    patientID = widget.patientID;
    phone = widget.phone;
  }

  Future<Consultation?> fetchAndReturnConsultation(int consultationID) async {
    Consultation? consultation = await Consultation.generateConsultationDetails(consultationID);
    if (consultation != null) {
      print('Consultation fetched: $consultation');
    } else {
      print('Failed to fetch consultation');
    }
    return consultation; // Return the consultation object or null
  }

  List<Widget> buildSymptomsList(String symptoms) {
    List<String> symptomList = symptoms.split(','); // Split the symptoms string by commas
    return List<Widget>.generate(symptomList.length, (index) {
      return Text(
        '${index + 1}) ${symptomList[index].trim()}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    });
  }

  Future<Consultation?> fetchPatientSpecificConsultationHistory(int consultationID, int patientID) async {
    Consultation? consultation = await Consultation.patientViewSpecificConsultationHistory(consultationID, patientID);
    if (consultation != null) {
      print('Consultation fetched: $consultation');
    } else {
      print('Failed to fetch consultation');
    }
    return consultation; // Return the consultation object or null
  }

  List<Widget> buildTreatmentsList(String treatments) {
    List<String> treatmentList = treatments.split(','); // Split the treatments string by commas
    return List<Widget>.generate(treatmentList.length, (index) {
      return Text(
        '${index + 1}) ${treatmentList[index].trim()}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, right: 20),
            child: Text(
              " Consultation Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          FutureBuilder<Consultation?>(
            future: fetchPatientSpecificConsultationHistory(consultationID, patientID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: 0.8,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: Text('No data available'),
                );
              } else {
                return Container(
                  width: double.infinity, // Make it full width
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10), // Add padding inside the container

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Specialist Name: ${snapshot.data!.specialistName}"
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            text: 'DateTime : ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              // Display treatments as a list
                              TextSpan(
                                text: '\n',
                              ),
                              WidgetSpan(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildTreatmentsList(snapshot.data!.consultationDateTime.toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(snapshot.data!.feesConsultationStatus.toString())
                    ],
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, right: 20),
            child: Text(
              " Consultation Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          FutureBuilder<Consultation?>(
            future: fetchAndReturnConsultation(consultationID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: 0.8,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: Text('No data available'),
                );
              } else {
                return Container(
                  width: double.infinity, // Make it full width
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10), // Add padding inside the container

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            text: 'Symptom : ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              // Display symptoms as a list
                              TextSpan(
                                text: '\n',
                              ),
                              WidgetSpan(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildSymptomsList(snapshot.data!.consultationSymptom.toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            text: 'Treatment : ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              // Display treatments as a list
                              TextSpan(
                                text: '\n',
                              ),
                              WidgetSpan(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildTreatmentsList(snapshot.data!.consultationTreatment.toString()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 30,),
                      Center(child: ElevatedButton(onPressed: (){}, child: Text("Pay Now")))
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
