import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Model/consultation.dart';
import '../../../Model/medication.dart';


class MedicationDetails extends StatefulWidget {
  final int consultationID;
  final int patientID;
  final String patientName;
  final String phone;


  MedicationDetails({required this.consultationID,
  required this.patientID,
  required this.patientName,
  required this.phone});

  @override
  _MedicationDetailsState createState() => _MedicationDetailsState();
}

class _MedicationDetailsState extends State<MedicationDetails> {
  Consultation? consultation;
  late int storedConsultID;
  late int consultationID;
  late int patientID;
  late String patientName;
  late String phone;
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



  Future<List<Medication>> fetchPatientMedication(int consultationID) async {
    Medication med = Medication(
        consultationID: consultationID,
        );
    print("consultation id ${consultationID}");
    print(med.fetchPatientMedication(consultationID));
    return await med.fetchPatientMedication(consultationID);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Column(children: [

          SizedBox(height: 30,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Medication Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        child: FutureBuilder<List<Medication>>(
                          future: fetchPatientMedication(consultationID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              List<Medication> meds = snapshot.data!;

                              if (meds.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: meds.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, index) {
                                    Medication med = meds[index];
                                    return SingleChildScrollView(
                                      child: Card(

                                        child: InkWell(
                                          child: Text(
                                            'Medicine Name: ${med.medGeneral} -${med.medForm} - ${med.dosage} \n '

                                                'Instruction: ${med.medInstruction}\n',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(child: Text('No history available'));
                              }
                            } else {
                              return Center(child: Text('No data available'));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]));
  }
}