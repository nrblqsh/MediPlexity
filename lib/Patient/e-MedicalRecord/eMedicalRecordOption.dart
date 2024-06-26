import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'medicalConsultationReport/allConsultationHistory.dart';


class MedicalRecordScreen extends StatefulWidget {
  final int patientID;
  final String patientName;
  final String phone;

  MedicalRecordScreen({
    required this.patientID,
  required this.patientName,
  required this.phone});

  @override
  _MedicalRecordScreenState createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  late int patientID;
  late String patientName;
  late String phone;

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    patientName = widget.patientName;
    phone = widget.phone;
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
                  text: 'Medical Record',
                ),
                CustomTab(
                  text: 'Vital Info History',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ConsultationHistory(patientID:patientID, patientName: patientName, phone: phone,),
              ConsultationHistory(patientID:patientID, patientName: patientName, phone: phone,),

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