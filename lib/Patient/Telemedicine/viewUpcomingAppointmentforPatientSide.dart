import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/Model/consultation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Model/specialist.dart';
import '../../main.dart';
import 'package:intl/intl.dart';


class ViewUpcomingAppointmentforPatientSide extends StatefulWidget {

  final int patientID;
  ViewUpcomingAppointmentforPatientSide({required this.patientID});

  @override
  State<ViewUpcomingAppointmentforPatientSide> createState() => _ViewUpcomingAppointmentforPatientSideState();
}

class _ViewUpcomingAppointmentforPatientSideState extends State<ViewUpcomingAppointmentforPatientSide> {


  bool isButtonEnabled = false; // Set it to false to disable the button
  late int patientID;

  // String specialistName ="";
  // String specialistPhone ="";
  // String logStatus = "OFFLINE";
  // String clinicName="";
  // String passwordSpecialist = "";
  // String specialistTitle = "";

  String consultationStatus = "";
  int specialistID = 0;
  DateTime? dateTime;


  @override
  void initState() {
    _loadData();
  }


  Future<void> _loadData() async {
    patientID = widget.patientID;
    print("patientID${patientID}");
    // Further processing...
  }


  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString); // Parse the string into a DateTime object
    return DateFormat('dd MMMM yyyy - hh:mm a').format(dateTime); // Format the DateTime object
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset(
            "assets/MYTeleClinic.png",
            width: 594,
            height: 258,
          ),
        ),
      ),
      body:SingleChildScrollView(
        child:

          Container(
            height: MediaQuery.of(context).size.height, // Set a fixed height or use other constraints
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,


                    child: Text(
                        'List Appointment', // Add your test text here
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),



                ),

                Expanded(
                    child: FutureBuilder<List<Consultation>>(
                      future: viewUpcomingAppointmentforPatientSide(patientID),
                      // Call fetchSpecialist() here
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<Consultation>? consultations = snapshot.data;
                          if (consultations != null && consultations.isNotEmpty) {
                            return ListView.builder(
                              itemCount: consultations.length,
                              itemBuilder: (BuildContext context, index) {
                                // Build each specialist profile here
                                Consultation consultation = consultations[index];

                                return GestureDetector(
                                  onTap: (){
                                    print("tekan");
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Appointment Details',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                              ),
                                              SizedBox(height: 10),



                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(

                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      "http://${MyApp.ipAddress}/mediplexity/getSpecialistImagePatientSide.php?specialistID=${consultation.specialistID}}",
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15,),
                                              Text(
                                                '${consultation.specialistName}',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                              ),
                                              Text(
                                                '${_formatDateTime(consultation.consultationDateTime.toString())}',
                                                style: TextStyle(

                                                    fontSize: 15
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        content: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                               Padding(
                                                 padding: const EdgeInsets.only(left: 24.0),
                                                 child: Text(
                                                  'Are you sure to cancel your appointment? You can set up another appointment later.',
                                                                                               ),
                                               ),


                                            SizedBox(height: 10),
                                            Center(
                                              child: Text(
                                                'Status: ${consultation.consultationStatus}',
                                              ),
                                            ),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed:
                                                consultation.consultationDateTime.isAfter(DateTime.now()) &&
                                                    consultation.consultationStatus != 'Decline'
                                                    ? () async {

                                                  showDialog(

                                                      context: context,
                                                      builder: (BuildContext context) {

                                                        return AlertDialog(
                                                          title: Text("Cancel Appointment"),
                                                          content: Text("Are you sure you want to cancel this appointment?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(); // Close the dialog
                                                              },
                                                              child: Text("Cancel"),
                                                            ),
                                                            TextButton(
                                                                onPressed: () async{
                                                                  bool _isAppointmentCanceled = false;

                                                                  print("consultation id on this button is ${consultation.consultationID}");
                                                                  if(consultation.consultationID!=null)
                                                                  {
                                                                    try {
                                                                      await Consultation
                                                                          .cancelAppointment(
                                                                          int.parse(
                                                                              consultation
                                                                                  .consultationID
                                                                                  .toString()));

                                                                      setState(() {
                                                                        _isAppointmentCanceled = true;


                                                                      });

                                                                      Fluttertoast.showToast(
                                                                        msg: "Appointment canceled successfully",
                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                        gravity: ToastGravity.TOP,
                                                                        backgroundColor: Colors.green,
                                                                        textColor: Colors.white,

                                                                      );
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context); // Navigate back to the previous screen
// Navigate back to the previous screen
                                                                    }
                                                                    catch(e)
                                                                    {
                                                                      print(e);
                                                                    }
                                                                  }
                                                                },
                                                                child: Text("Confirm"))
                                                          ],
                                                        );
                                                      }
                                                  );




                                                }
                                                    : null, // Disable button if overdue
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                  Colors.red,
                                                ),
                                                child: Text(
                                                    'Cancel Appointment', style: TextStyle(
                                                  color: Colors.white
                                                ),),

                                              ),
                                            ),
                                            Center(
                                              child: TextButton(
                                                onPressed: () async {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => ViewAppointmentScreen(patientID: patientID,)),
                                                  // );
                                                  Navigator.pop(context);
                                                },

                                                child: Text('Close'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [

                                        SizedBox(height: 10,),
                                    Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left:10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${_formatDateTime(consultation.consultationDateTime.toString())}',
                                                      style: TextStyle(fontSize: 15,
                                                          ),
                                                    ),
                                                    SizedBox(width: 8),
                                                  ],
                                                ),
                                                //
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left:10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${consultation.specialistName}',
                                                      style: TextStyle(fontSize: 12,
                                                          color: Colors.grey,
                                                      fontWeight: FontWeight.w400),
                                                    ),
                                                    SizedBox(width: 8),
                                                  ],
                                                ),
                                                //
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:5.0, left: 8),
                                                child: Container(
                                                  height: 23,
                                                  width: 75,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: _getStatusColor(consultation.consultationStatus),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${consultation.consultationStatus}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),


                                    ),
                                  ],
                                  ),
                                  ),
                                );


                              },
                            );
                          } else {
                            // Handle case when specialists list is null
                            return Text('No specialists found');
                          }
                        } else {
                          // Handle other cases
                          return Text('Unknown state');
                        }
                      },
                    ),
                  ),

              ],
            ),
          )



      ),


    );
  }

   Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Decline':
        return Colors.red;
      case 'Pending':
        return hexColor('FFC000');
      default:
        return Colors.transparent;
    }
  }
  Color hexColor(String color) {
    String newColor = '0xff' + color.replaceAll('#', '');
    int finalColor = int.parse(newColor);
    return Color(finalColor);
  }

  Widget _buildOnlineIndicator(String logStatus) {
    Color indicatorColor = logStatus == "OFFLINE" ? Colors.red : Colors.green;
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: indicatorColor,
      ),
    );
  }


  Future<List<Consultation>> viewUpcomingAppointmentforPatientSide(
      int patientID) async {
    Consultation consultation = Consultation(
      patientID: patientID,
      consultationDateTime: DateTime.now(),
      specialistID: 0,
      consultationStatus: '',
    );
    print("okkk");

    // print(Specialist.viewSpecialistforPatientSide());
    return await Consultation.viewUpcomingAppointmentforPatientSide(patientID);
  }
}



