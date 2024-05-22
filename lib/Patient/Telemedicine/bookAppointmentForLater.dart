import 'package:flutter/material.dart';
import 'package:fyp/Model/consultation.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';


class BookAppointmentForLater extends StatefulWidget {
  final int specialistID;
  final int patientID;
  final String clinicName;
  final String specialistName;
  final String specialistTitle;
   BookAppointmentForLater({
     required this.specialistID,
     required this.patientID,
     required this.clinicName,
     required this.specialistName,
     required this.specialistTitle
   });

  @override
  State<BookAppointmentForLater> createState() => _BookAppointmentForLaterState();
}

class _BookAppointmentForLaterState extends State<BookAppointmentForLater> {


  late int patientID;
  late int specialistID;
  late String clinicName;
  late String specialistName;
  late String specialistTitle;
  DateTime? dateTime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  Future<void> loadData() async {
    patientID = widget.patientID;
    specialistID = widget.specialistID;
    clinicName = widget.clinicName;
    specialistName = widget.specialistName;
    specialistTitle = widget.specialistTitle;

    print("patient id is ${patientID}");
    print("specialistIDDDD is ${specialistID}");//


    showDateTimePicker();//   final SharedPreferences prefs = await SharedPreferences.getInstance();

  }


  Future<void> showDateTimePicker() async {
    dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    print("dateTime: $dateTime");

    // Once the date time picker is closed, save the consultation
    saveConsultation();
  }

  Future<void> saveConsultation() async {
    Consultation consult = Consultation(
      patientID: int.parse(patientID.toString()),
      consultationDateTime: dateTime ?? DateTime.now(),
      specialistID: specialistID,
      consultationStatus: "Pending",
    );

    bool success = await consult.save();

    if (success) {
      print("request success");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni DateTime Picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: Scaffold(
        body: Center(
          child: Container(),
        ),
      ),
    );
  }
}