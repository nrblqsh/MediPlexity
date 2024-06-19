import 'package:flutter/material.dart';
import 'package:fyp/Patient/e-MedicalRecord/medicalConsultationReport/specificConsultationDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'medicationDetails.dart';



class ConsultationDetailsOption extends StatefulWidget {
  final int consultationID;
  final int patientID;
  final String patientName;
  final String phone;

  ConsultationDetailsOption({
    required this.consultationID,
    required this.patientID,
    required this.patientName,
    required this.phone});

  @override
  _ConsultationDetailsOptionScreenState createState() => _ConsultationDetailsOptionScreenState();
}

class _ConsultationDetailsOptionScreenState extends State<ConsultationDetailsOption> {
  late int patientID;
  late String patientName;
  late String phone;
  late int consultationID;

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    patientName = widget.patientName;
    phone = widget.phone;
    consultationID = widget.consultationID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 78,
            backgroundColor: Colors.white,
            title: Center(
              child: Image.asset(
                "assets/MYTeleClinic.png",
                width: 594,
                height: 258,
              ),
            ),
            bottom: TabBar(
              unselectedLabelColor: Colors.orangeAccent,
              labelColor: Colors.blueGrey,
              //
              indicatorColor: Colors.blueGrey,
              // Set the color for the selected label
              tabs: [
                CustomTab(
                  text: 'Consultation Details',
                ),
                CustomTab(
                  text: 'Medication Details',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SpecificConsultationDetails(patientID:patientID, patientName: patientName, phone: phone,consultationID: consultationID,),
              MedicationDetails(patientID:patientID, patientName: patientName, phone: phone, consultationID: consultationID,),

            ],
          ),

        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  //final Icon icon;

  final String text;

  CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Column(
        children: [
          const SizedBox(height: 20),
          Text(text),
        ],
      ),
    );
  }
}