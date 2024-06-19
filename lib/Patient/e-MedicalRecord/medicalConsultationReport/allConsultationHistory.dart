import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/consultation.dart';
import '../../../main.dart';
import 'consultationDetailsOption.dart';
import 'medicationDetails.dart';



class ConsultationHistory extends StatefulWidget {
  final int patientID;
  final String patientName;
  final String phone;



  ConsultationHistory(
      {required this.patientID,
      required this.patientName,
      required this.phone,
      });

  @override
  _ConsultationHistoryState createState() => _ConsultationHistoryState();
}

class _ConsultationHistoryState
    extends State<ConsultationHistory> {
  late int patientID;
  late String patientName;
  late String phone;
  String specialistName = "";

  //late String logStatus;
  DateTime consultationDateTime = DateTime.now();
  int specialistID = 0;
  int consultationID = 0;
  int medID = 0;
  int medicationID = 0;
  String consultationStatus = '';
  String consultationSymptom = '';
  String consultationTreatment = '';
  String feesConsultationStatus = '';

  // String medGeneral = '';
  // String medForm = '';
  // late List<Consultation> todayConsultations = [];

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    patientName = widget.patientName;
    phone = widget.phone;
  }


  Future<List<Consultation>> fetchPatientConsultationHistory(
      int patientID) async {
    try {
      // Use the patientViewConsultationHistory method to fetch consultation history
      List<Consultation> consultations = await Consultation
          .patientViewConsultationHistory(patientID);
      return consultations;
    } catch (e) {
      print('Error fetching consultation history: $e');
      return []; // Return an empty list in case of error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 20),
                child: Text(
                  'Consultation History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: FutureBuilder<List<Consultation>>(
                future: fetchPatientConsultationHistory(widget.patientID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Consultation> consultations = snapshot.data!;

                    if (consultations.isNotEmpty) {
                      return ListView.builder(
                        itemCount: consultations.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          Consultation consult = consultations[index];
                          return Card(
                            child: GestureDetector(
                              onTap: () async {
                                Consultation consult = consultations[index];
                                if (consult.consultationID != null) {
                                  final int selectedConsultationID = consult
                                      .consultationID!;
                                  print(
                                      'consult id tapped - $selectedConsultationID');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationDetailsOption(
                                            consultationID: selectedConsultationID,
                                            patientID: patientID,
                                            patientName: patientName,
                                            phone: phone,),
                                    ),
                                  );
                                } else {
                                  print('Selected consultationID is null');
                                }
                              },
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 700,
                                        height: 135,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 12, right: 12, top: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blueGrey,
                                                offset: const Offset(5.0, 5.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                              ),
                                              BoxShadow(
                                                color: Colors.white,
                                                offset: const Offset(0.0, 0.0),
                                                blurRadius: 0.0,
                                                spreadRadius: 0.0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(
                                                '${consult.specialistName}',
                                                style: TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Date: ${DateFormat(
                                                    'dd/MM/yyyy').format(consult
                                                    .consultationDateTime)}\n'
                                                    'Time: ${DateFormat(
                                                    'hh:mm a').format(consult
                                                    .consultationDateTime)}',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(height: 10),


                                              Container(
                                                height: 23,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                  color: Color(_getStatusColor(
                                                      consult
                                                          .feesConsultationStatus
                                                          .toString())),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${consult
                                                        .feesConsultationStatus}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
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
          ],
        ),
      ),
    );
  }


// void _showConsultationMedicationDialog(BuildContext context, Medication medication) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Consultation Medication'),
//         contentPadding: EdgeInsets.all(10),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text('Date: ${DateFormat('dd/MM/yyyy').format(consultation.consultationDateTime)}'),
//             Text('Time: ${DateFormat('hh:mm a').format(consultation.consultationDateTime)}'),
//             Text('Symptom: ${consultation.consultationSymptom}'),
//             Text('Treatment: ${consultation.consultationTreatment}'),
//             // Add more details as needed
//             SizedBox(height: 16), // Add some space between the details and buttons
//
//           ],
//         ),
//       );
//     },
//   );
// }

  int _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green.value;
      case 'Pending Payment':
        return Colors.red.value;
      default:
        return Colors.transparent.value; // Default color
    }
  }
}