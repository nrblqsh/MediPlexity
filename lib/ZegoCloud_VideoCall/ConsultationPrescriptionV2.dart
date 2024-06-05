import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fyp/Model/medication.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:http/http.dart' as http;

import '../Controller/requestController.dart';
import '../Model/patient.dart';

class ConsultationPrescription extends StatefulWidget {
  final int patientID;
  final String patientName;
  final int consultationID;
  final int roleID;
  final int specialistID;

  const ConsultationPrescription({
    Key? key,
    required this.patientName,
    required this.patientID,
    required this.consultationID,
    required this.roleID,
    required this.specialistID,
  }) : super(key:key);

  @override
  State<ConsultationPrescription> createState() =>
      _ConsultationPrescriptionState();
}

class _ConsultationPrescriptionState extends State<ConsultationPrescription> with AutomaticKeepAliveClientMixin{
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


  int? _medID ;
  String? _medGeneral;
  String? _medForm;
  String? _dosage;
  int? _medicationID ;
  String? _medInstruction;

  List<Medication> medications = [];
  List<String> originalMedicationNames = [];
  List<FocusNode> focusNodes = [];
  List<String> medicationNames = ['']; // Initialize with an empty symptom
  List<TextEditingController> medicationControllers = [TextEditingController()];
  List<String> symptoms = ['']; // Initialize with an empty symptom
  List<TextEditingController> symptomControllers = [TextEditingController()];
  TextEditingController treatmentController = TextEditingController();

  List<TextEditingController> dosageController = [TextEditingController()];
  List<TextEditingController> medFormController = [TextEditingController()];
  List<String> medicineForms = ['Tablet', 'Capsule', 'Syrup', 'Suspension', 'Injection', 'Cream', 'Ointment', 'Drops', 'Patch', 'Inhaler'];
  List<TextEditingController> medInstructionControllers = [];

  late List<bool> showSuggestion = [false];
  bool showMedFormSuggestion =false;
  late List<bool> showDosageTextField = [false];
  late List<bool> showMedFormTextField = [false];
  bool showPredictButton = false;
  late List<bool> showMedicationInstructionField = [false];



  List<String> symptomsList = [];
  List<String> serverSymptomsList = [];



  List<List<String>> medicationFormSuggestions = [];




  @override
  void initState() {

    super.initState();
    patientID = widget.patientID;
    patientName = widget.patientName;
    consultationID = widget.consultationID;
    roleID = widget.roleID;
    specialistID = widget.specialistID;
    _loadInfoPatient(patientID);
    _loadAllMedicine();
    saveSymptoms();

    medicationFormSuggestions = List.generate(medicationControllers.length, (index) => medicineForms);

    medInstructionControllers = List.generate(
      medicationControllers.length,
          (index) => TextEditingController(),
    );

    showDosageTextField = [false];
    showMedFormTextField = [false];
    dosageController = [TextEditingController()];
    medFormController = [TextEditingController()];

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


  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {

    treatmentController.dispose();
    for (var controller in symptomControllers) {
      controller.dispose();
    }

    for (var controller in medicationControllers) {
      controller.dispose();
    }

    for (var controller in dosageController) {
      controller.dispose();
    }
    for (var controller in medFormController) {
      controller.dispose();
    }


    super.dispose();
  }
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
        symptomControllers[index].dispose(); // Dispose the corresponding controller
        symptomControllers.removeAt(index); // Remove the controller from the list
        showPredictButton = true;
      }
    });
  }


  void addMedication() {
    setState(() {
      medicationControllers.add(TextEditingController());
      showSuggestion.add(true);
      showDosageTextField.add(false);
      showMedFormTextField.add(false);
      dosageController.add(TextEditingController());
      medFormController.add(TextEditingController());
      medInstructionControllers.add(TextEditingController()); // Add a new controller for medication instructions
      showMedicationInstructionField.add(false);
      medicationFormSuggestions.add([...medicineForms]); // Assuming medicineForms is a list of medicine form suggestions

    });
  }


  void addFormandDosage() {
    setState(() {
      showDosageTextField.add(false);
      showMedFormTextField.add(false);
      dosageController.add(TextEditingController());
      medFormController.add(TextEditingController());
      //showMedicationInstructionField.add(false);


    });
  }


  void removeMedication(int index) {
    setState(() {
      if (medicationControllers.length > 1) {

        medicationControllers[index].dispose();
        medicationControllers.removeAt(index);
        dosageController[index].dispose();
        dosageController.removeAt(index);
        medFormController[index].dispose();
        medFormController.removeAt(index);
        showSuggestion.removeAt(index);
        medicationFormSuggestions.removeAt(index);
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    super.build(context);

    Map<String, dynamic> resultData = data != null ? jsonDecode(data!) : {};


    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(patientName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    softWrap: true,
                    overflow: TextOverflow.visible,),
                  ),

                  if (!isCallButtonClicked)
                    sendCallButton(
                      patientID: patientID.toString(),
                      patientName: patientName,
                      onCallFinished: (code, message, errorInvitees) {
                        onSendCallInvitationFinished(
                            code, message, errorInvitees);
                        setState(() {
                          isCallButtonClicked = true;
                        });
                      },
                    ),
                ],
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
              SizedBox(height: 40, width: 70,),
              Center(
                child: Text(
                  "Patient Prescription",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  if (symptoms.isNotEmpty) // Check if symptoms list is not empty
                    ...List.generate(symptoms.length, (index) {
                      return Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: symptomControllers[index],
                              onChanged: (value) {
                                symptoms[index] = value;
                                fetchSymptoms();
                              },
                              decoration: InputDecoration(
                                labelText: 'Symptom ${index + 1}',
                              ),
                              onSubmitted: (_) {
                                // Dismiss the keyboard
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
                ],
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

              SizedBox(height: 20,),
              Column(
                children: List.generate(medicationControllers.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: medicationControllers[index],
                              onTap: () {
                                setState(() {
                                  showMedicationInstructionField[index] = true;
                                  showMedFormTextField[index] = false;
                                  showDosageTextField[index] = false;


                                  showSuggestion[index] = true;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    medicationNames = List.from(originalMedicationNames); // Reset to original list if TextField is empty
                                  } else {
                                    medicationNames = originalMedicationNames
                                        .where((name) => name.toLowerCase().contains(value.toLowerCase()))
                                        .toList();
                                  }
                                });
                              },
                              onSubmitted: (value) {
                                setState(() {
                                  print('Index: $index, medicationFormSuggestions length: ${medicationFormSuggestions.length}');
                                  if (medicationFormSuggestions.isNotEmpty && index < medicationFormSuggestions.length) {
                                    if (index == medicationControllers.length - 1 && medicationControllers[index].text.isNotEmpty) {
                                      addFormandDosage();
                                    }
                                    showSuggestion[index] = false;
                                    showMedicationInstructionField[index] = true;
                                    showDosageTextField[index] = true;
                                    if (!showMedFormTextField[index]) {
                                      showMedFormTextField[index] = true; // Show dosage field for the submitted medication
                                    }
                                  }
                                  // Update the showSuggestion state based on the value of the medication name field
                                  showSuggestion[index] = value.isEmpty;
                                });
                              },



                              decoration: InputDecoration(
                                labelText: 'Medication ${index + 1}',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeMedication(index);
                            },
                          ),
                          if (index == medicationControllers.length - 1)
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: addMedication,
                            ),
                        ],
                      ),
                      if (showSuggestion[index] && medicationNames.isNotEmpty)
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemCount: medicationNames.length,
                            itemBuilder: (context, medIndex) {
                              return ListTile(
                                title: Text(medicationNames[medIndex]),
                                onTap: () {
                                  setState(() {
                                    medicationControllers[index].text = medicationNames[medIndex];
                                    showSuggestion[index] = false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      if (showMedFormTextField[index] || showDosageTextField[index])
                        Row(
                          children: [
                            if (showDosageTextField[index])
                              Expanded(
                                child: TextField(
                                  controller: dosageController[index],
                                  decoration: InputDecoration(
                                    labelText: 'Dosage (mg/ml)',
                                  ),
                                ),
                              ),
                            SizedBox(width: 10),
                            if (showMedFormTextField[index])
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: medFormController[index],
                                      decoration: InputDecoration(
                                        labelText: '${getMedicationName(medicationControllers[index].text)} Form',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          // Toggle the showMedFormSuggestion based on whether the value is empty or not
                                          showMedFormSuggestion = value.isNotEmpty;
                                          // Filter the medicine forms based on user input
                                          medicationFormSuggestions[index] = medicineForms
                                              .where((form) => form.toLowerCase().contains(value.toLowerCase()))
                                              .toList();
                                        });
                                      },
                                    ),
                                    if (medicationFormSuggestions[index].isNotEmpty && showMedFormSuggestion)
                                      Container(
                                        height: 100,
                                        child: ListView.builder(
                                          itemCount: medicationFormSuggestions[index].length,
                                          itemBuilder: (context, formIndex) {
                                            return ListTile(
                                              title: Text(medicationFormSuggestions[index][formIndex]),
                                                onTap: () {
                                                  setState(() {
                                                    if (medicationFormSuggestions[index].isNotEmpty && formIndex < medicationFormSuggestions[index].length) {
                                                      medFormController[index].text = medicationFormSuggestions[index][formIndex];
                                                      medicationFormSuggestions[index] = []; // Clear suggestions
                                                      showMedFormSuggestion = false;
                                                    }
                                                  });
                                                }

                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if( showMedicationInstructionField[index])

                          //SizedBox(height: 10),
                          TextField(
                            controller: medInstructionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Instructions ${getMedicationName(medicationControllers[index].text)}',

                            ),
                            maxLines: null
                          ),
                    ],
                  );
                }),
              ),


              TextField(

                controller: treatmentController,
                decoration: InputDecoration(labelText: 'Treatment'),
                maxLines: null,
              ),

              ElevatedButton(onPressed: (){
                printEnteredData();
              },
                  child: Text("press")),
              SizedBox(height: 16),
              if (isCallButtonClicked)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle save button press
                    },
                    child: Text('Save'),
                  ),
                ),
              SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }

  String getMedicationName(String fullString) {
    List<String> parts = fullString.split(' - ');
    return parts.isNotEmpty ? parts.first : fullString;
  }


  Future<void> _loadInfoPatient(int patientID) async {
    List<Patient> patients = await Patient.loadAll(patientID);

    if (patients.isNotEmpty) {
      Patient firstPatient = patients.first;

      print("Raw JSON Data: ${firstPatient.toJson()}");

      setState(() {
        _icNum = firstPatient.icNumber ?? 'N/A';
        _gender = firstPatient.gender ?? 'Select Gender';
        _age = calculateAgeFromIC(_icNum);
      });

      print("Patient Information:");
      print("IC Number: $_icNum");
      print("Gender: $_gender");
      print("Age: $_age");
      print("\n");
    } else {
      print('No patient data available');
    }
  }

  void printEnteredData() {
    print("Entered Treatment: ${treatmentController.text}");

    for (int i = 0; i < medicationControllers.length; i++) {
      List<String> parts = medicationControllers[i].text.split(' - ');
      if (parts.length >= 3) {
        String name = parts[0];
        String form = parts[1];
        String dosage = parts[2];

        print("Entered Medication ${i + 1} Name: $name");
        print("Entered Medication ${i + 1} Form: $form");
        print("Entered Medication ${i + 1} Dosage: $dosage");
        print("Entered Instructions ${i + 1}: ${medInstructionControllers[i].text}");
      } else {
        String name = medicationControllers[i].text;
        String dosage = dosageController[i].text;
        String form = medFormController[i].text;
        print("Entered Medication ${i + 1} Name: $name");
        print("Entered Medication ${i + 1} form: $form");
        print("Entered Medication ${i + 1} dosage: $dosage");
        print("Entered Instructions ${i + 1}: ${medInstructionControllers[i].text}");


      }
    }

    for (int i = 0; i < symptoms.length; i++) {
      print("Entered Symptom ${i + 1}: ${symptomControllers[i].text}");
    }
  }


  Future<void> _loadAllMedicine() async {
    List<Medication> meds = await Medication.loadAllMedications();

    if (meds.isNotEmpty) {
      setState(() {
        medications = meds;
        medicationNames = meds.map((med) => '${med.medGeneral ?? ''} - ${med.medForm ?? ''} - ${med.dosage ?? ''}').toList();
        originalMedicationNames = List.from(medicationNames);

        print("medName${medicationNames}");// Save original medication names

      });
      for (Medication med in meds) {
        print("medid${med.medID}");
        print("medicationid${med.medicationID}");
        print("medgeneral${med.medGeneral}");
        print(med.medForm);
      }
    } else {
      print('No medication data available');
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



  Widget buildPointForm(String title, List<String> items) {
    return Container(
      width:350,
      margin: EdgeInsets.symmetric(vertical: 10.0), // Add margin for separation between forms
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
          SizedBox(height: 5), // Add some space between the title and items
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text('➤ $item'),
          )).toList(),
        ],
      ),
    );
  }


  void onSendCallInvitationFinished(String code, String message,
      List<String> errorInvitees) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }
        var userID = errorInvitees.elementAt(index);
        userIDs += userID + ' ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }
      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  Widget sendCallButton({
    required String patientID,
    required String patientName,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    return ZegoSendCallInvitationButton(
      isVideoCall: true,
      invitees: [
        ZegoUIKitUser(
          id: patientID,
          name: patientName,
        ),
      ],
      resourceID: "zego_data",
      iconSize: const Size(40, 40),
      buttonSize: const Size(50,50),
      onPressed: onCallFinished,
    );
  }
}
