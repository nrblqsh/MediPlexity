import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/medication.dart';
import '../Model/patient.dart';

class PatientPastMedication extends StatefulWidget {
  final int patientID;
  final int specialistID;

  const PatientPastMedication({
    required this.patientID,
    required this.specialistID,
  });

  @override
  State<PatientPastMedication> createState() => _PatientPastMedicationState();
}

class _PatientPastMedicationState extends State<PatientPastMedication> {
  late int patientID;
  late int specialistID;

  String _patientName = "";
  String _icNum = "";
  String _gender = "";
  int _age = 0;

  List<Medication> _patientPastMedicine = [];
  late Future<List<Medication>> patientPastMedicine;

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    specialistID = widget.specialistID;
    _loadInfoPatient(patientID);
    patientPastMedicine = loadPastMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 4.0),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), // Adjust padding to create space for the border
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey[300]!), // Add a border on all sides of the container
            //
            //   ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patientName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Gender: $_gender',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 85,),
                    Text(
                      'Age: $_age',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Text("Patient's Past Symptoms",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,

          ),),
          FutureBuilder<List<Medication>>(
            future: patientPastMedicine,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No past medications found.'));
              } else {
                _patientPastMedicine = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: _patientPastMedicine.length,
                    itemBuilder: (context, index) {
                      final medication = _patientPastMedicine[index];
                      List<String> symptoms = medication.consultationSymptom?.split(',') ?? ['No symptoms'];
                      return Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!, // Change the color as needed
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: ListTile(

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align the symptoms to the start
                            children: [
                              ...symptoms.map((symptom) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('• ', style: TextStyle(fontSize: 16)),
                                    Flexible(
                                      child: Text(
                                        symptom.trim(),
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                medication.consultationDateTimeFinished != null
                                    ? DateFormat('dd-MM-yyyy').format(medication.consultationDateTimeFinished!)
                                    : 'No time',
                              ),
                              Text(
                                medication.consultationDateTimeFinished != null
                                    ? DateFormat(' hh:mm a').format(medication.consultationDateTimeFinished!)
                                    : 'No time',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Medication>> loadPastMedicine() async {
    try {
      List<Medication> patientMedicine = await Medication.getConsultationMedicationDuringVideoCallforSpecialist(patientID);
      if (mounted) {
        setState(() {
          _patientPastMedicine = patientMedicine;
        });
      }
      print(_patientPastMedicine);
      return patientMedicine;
    } catch (error) {
      print('$error');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> _loadInfoPatient(int patientID) async {
    List<Patient> patients = await Patient.loadAll(patientID);

    if (patients.isNotEmpty) {
      Patient firstPatient = patients.first;

      print("Raw JSON Data: ${firstPatient.toJson()}");

      setState(() {
        _patientName = firstPatient.patientName ?? 'N/A';
        _icNum = firstPatient.icNumber ?? 'N/A';
        _gender = firstPatient.gender ?? 'Select Gender';
        _age = calculateAgeFromIC(_icNum);
      });

      print("Patient Information:");
      print("Name: $_patientName");
      print("IC Number: $_icNum");
      print("Gender: $_gender");
      print("Age: $_age");
      print("\n");
    } else {
      print('No patient data available');
    }
  }


  int calculateAgeFromIC(String ic) {
    if (ic.length < 6) return 0;

    // Extract birth date from IC number
    String birthDateStr = ic.substring(0, 6);
    String yearStr = birthDateStr.substring(0, 2);
    String monthStr = birthDateStr.substring(2, 4);
    String dayStr = birthDateStr.substring(4, 6);

    // Determine the full year
    int year = int.parse(yearStr);
    if (year < 50) {
      year += 2000; // Assume 2000+ for YY < 50
    } else {
      year += 1900; // Assume 1900+ for YY >= 50
    }

    // Create birth date object
    DateTime birthDate = DateTime(year, int.parse(monthStr), int.parse(dayStr));
    DateTime currentDate = DateTime.now();

    // Calculate age
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
