import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fyp/Model/medication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:http/http.dart' as http;

import '../Controller/requestController.dart';
import '../Model/patient.dart';
import 'ConsultationPrescriptionV2.dart';

class DoPrediction extends StatefulWidget {
  final int patientID;
  final String patientName;
  final int consultationID;
  final int roleID;
  final int specialistID;
// Add symptoms field


  const DoPrediction({
    Key? key,
    required this.patientName,
    required this.patientID,
    required this.consultationID,
    required this.roleID,
    required this.specialistID,
  });

  @override
  State<DoPrediction> createState() => _DoPredictionState();
}

class _DoPredictionState extends State<DoPrediction> with AutomaticKeepAliveClientMixin {
  bool isCallButtonClicked = false;
  late int patientID;
  late int consultationID;
  late String patientName;
  late int roleID;
  late int specialistID;
  String? data;
  String _icNum = "";
  String _gender = "";
  int _age = 0;

  int? _medID;
  String? _medGeneral;
  String? _medForm;
  String? _dosage;
  int? _medicationID;
  String? _medInstruction;

  List<String> symptoms = ['']; // Initialize with an empty symptom
  List<TextEditingController> symptomControllers = [TextEditingController()];

  List<bool> showSuggestion = [false];

  bool showPredictButton = false;
  bool showAddSymptomtoAnotherPageButton = false;

  List<String> symptomsList = [];
  List<String> serverSymptomsList = [];

  @override
  void initState() {
    super.initState();

    patientID = widget.patientID;
    patientName = widget.patientName;
    consultationID = widget.consultationID;
    roleID = widget.roleID;
    specialistID = widget.specialistID;
    saveSymptoms();
  }

  @override
  void dispose() {
    for (var controller in symptomControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void addSymptom() {
    setState(() {
      symptoms.add('');
      symptomControllers.add(TextEditingController());
      showPredictButton = true;
    });
  }

  void removeSymptom(int index) {
    setState(() {
      if (symptoms.length > 1) {
        symptoms.removeAt(index);
        symptomControllers.removeAt(index).dispose();
        showPredictButton = true;
      }
    });
  }


  Future<void> fetchSymptoms() async {
    RequestController requestController = RequestController(path: ':8000/symptoms');

    await requestController.get(); // Assuming you have a get method in your RequestController

    if (requestController.status() == 200) {
      setState(() {
        symptomsList = List<String>.from(requestController.result()['symptoms']);
      });
    } else {
      throw Exception('Failed to load symptoms: ${requestController.status()}');
    }
  }

  Future<void> saveSymptoms() async {
    RequestController requestController = RequestController(path: ':8000/symptoms');

    await requestController.get(); // Assuming you have a get method in your RequestController

    if (requestController.status() == 200) {
      setState(() {
        serverSymptomsList = List<String>.from(requestController.result()['symptoms']);
      });
    } else {
      throw Exception('Failed to load symptoms: ${requestController.status()}');
    }
  }

  Future<void> predictMedicine() async {
    List<String> filteredSymptoms = symptoms
        .map((symptom) => symptom.trim())
        .where((symptom) => symptom.isNotEmpty && serverSymptomsList.contains(symptom))
        .toList();

    print("symptom yg masuk:${filteredSymptoms}");

    if (filteredSymptoms.isEmpty) {
      showToast('No valid symptoms to predict',
          position: StyledToastPosition.top, context: context);
      return;
    }

    RequestController requestController = RequestController(
      path: ':8000/forDoc',
    );

    requestController.setBody({'symptoms': filteredSymptoms});

    await requestController.post();

    if (requestController.status() == 200) {
      var result = requestController.result();
      print(result);

      setState(() {
        data = jsonEncode(requestController.result());
        showPredictButton = false;
        showAddSymptomtoAnotherPageButton = true;
      });
    } else {
      showToast('Failed to predict medicine',
          position: StyledToastPosition.top, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Map<String, dynamic> resultData = data != null ? jsonDecode(data!) : {};

    List<String> symptomsEntered = resultData['symptoms'] != null ? List<String>.from(resultData['symptoms']) : [];
    List<String> recommendedMedicines = resultData['medications'] != null ? List<String>.from(resultData['medications'][0].split(',')) : [];
    List<String> precautions = resultData['precautions'] != null ? List<String>.from(resultData['precautions'][0]) : [];
    List<String> predicted_disease = resultData['predicted_disease'] != null ? [resultData['predicted_disease']] : [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:
                const EdgeInsets.only( top: 10, right: 20),
                child: Text(
                  "Enter Patient's Symptoms ",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.only( top: 10, right: 20),
                child: Text(
                  "While our AI prediction is advanced, please note that it may not be 100% accurate."
                      " Let's get started!",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              SizedBox(height: 8),
              Column(
                children: List.generate(symptoms.length, (index) {
                  return Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: symptomControllers[index],
                          onChanged: (value) {
                            showPredictButton = true;
                            symptoms[index] = value;
                            fetchSymptoms(); // Call the method to fetch symptoms
                          },
                          decoration: InputDecoration(
                            labelText: 'Symptom ${index + 1}',
                          ),
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                            symptomsList.clear();
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeSymptom(index);
                        },
                      ),
                      if (index == symptoms.length - 1)
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: addSymptom,
                        ),
                    ],
                  );
                }),
              ),
              if (symptomsList.isNotEmpty)
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: symptomsList.length,
                    itemBuilder: (context, index) {
                      final filteredSymptoms = symptomsList.where((symptom) {
                        for (var controller in symptomControllers) {
                          if (controller.text.isNotEmpty &&
                              symptom.toLowerCase().contains(controller.text.toLowerCase())) {
                            return true;
                          }
                        }
                        return false;
                      }).toList();
                      if (index < filteredSymptoms.length) {
                        return ListTile(
                          title: Text(filteredSymptoms[index]),
                          onTap: () {
                            symptomControllers[symptoms.length - 1]
                                .text = filteredSymptoms[index];
                            symptoms[symptoms.length - 1] = filteredSymptoms[index];
                            setState(() {
                              symptomsList.clear();
                            });
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
              data != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPointForm('Symptoms', symptomsEntered),
                  buildPointForm('Predicted Disease', predicted_disease),
                  buildPointForm('Medications', recommendedMedicines),
                ],
              )
                  : Text(""),
              if (showPredictButton)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      predictMedicine();
                    },
                    child: Text('Predict Medicine'),
                  ),
                ),
              SizedBox(height: 16),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildPointForm(String title, List<String> items) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text('➤ $item'),
          )).toList(),
        ],
      ),
    );
  }
}
