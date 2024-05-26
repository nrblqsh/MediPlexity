import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ConsultationPrescription extends StatefulWidget {
  final int patientID;
  final String patientName;
  final int consultationID;
  final int roleID;
  final int specialistID;

  const ConsultationPrescription({
    required this.patientName,
    required this.patientID,
    required this.consultationID,
    required this.roleID,
    required this.specialistID,
  });

  @override
  State<ConsultationPrescription> createState() => _ConsultationPrescriptionState();
}

class _ConsultationPrescriptionState extends State<ConsultationPrescription> {
  bool isCallButtonClicked = false; // State variable to track button click
  late int patientID;
  late int consultationID;
  late String patientName;
  late int roleID;
  late int specialistID;

  TextEditingController medicationController = TextEditingController();
  List<TextEditingController> symptomControllers = [TextEditingController()];
  TextEditingController treatmentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    patientID = widget.patientID;
    patientName = widget.patientName;
    consultationID = widget.consultationID;
    roleID = widget.roleID;
    specialistID = widget.specialistID;
  }
  @override
  void dispose() {
    medicationController.dispose();
    treatmentController.dispose();
    for (var controller in symptomControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(patientName),
                  if (!isCallButtonClicked) // Show only if call button is not clicked
                    sendCallButton(
                      patientID: patientID.toString(),
                      patientName: patientName,
                      onCallFinished: (code, message, errorInvitees) {
                        onSendCallInvitationFinished(code, message, errorInvitees);
                        setState(() {
                          isCallButtonClicked = true; // Update state to hide the call button
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 16),
              Text("Symptoms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Column(
                children: symptomControllers.map((controller) {
                  int index = symptomControllers.indexOf(controller);
                  return Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Symptom ${index + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (symptomControllers.length > 1) {
                            setState(() {
                              symptomControllers.removeAt(index);
                            });
                          }
                        },
                      ),
                      if (index == symptomControllers.length - 1) // Add button only to the last item
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              symptomControllers.add(TextEditingController());
                            });
                          },
                        ),
                    ],
                  );
                }).toList(),
              ),
              TextField(
                controller: medicationController,
                decoration: InputDecoration(labelText: 'Medication'),
              ),

              TextField(
                controller: treatmentController,
                decoration: InputDecoration(labelText: 'Treatment'),
              ),
              SizedBox(height: 16),
              // Add more fields as needed
              if (isCallButtonClicked) // Show save button if call button is clicked
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle save button press
                    },
                    child: Text('Save'),
                  ),
                ),
              SizedBox(height: 100), // Add some space at the bottom to prevent the save button from being covered
            ],
          ),
        ),
      ),
    );
  }

  void onSendCallInvitationFinished(
      String code, String message, List<String> errorInvitees) {
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
      buttonSize: const Size(50, 50),
      onPressed: onCallFinished,
    );
  }
}
