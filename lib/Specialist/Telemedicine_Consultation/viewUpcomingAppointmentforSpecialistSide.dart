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

import '../specialistHomePage.dart';


class ViewUpcomingAppointmentforSpecialistSide extends StatefulWidget {

  final int specialistID;
  final String specialistName;
  final String phone;
  ViewUpcomingAppointmentforSpecialistSide({required this.specialistID,
  required this.specialistName,
  required this.phone});

  @override
  State<ViewUpcomingAppointmentforSpecialistSide> createState() => _ViewUpcomingAppointmentforSpecialistSideState();
}

class _ViewUpcomingAppointmentforSpecialistSideState extends State<ViewUpcomingAppointmentforSpecialistSide> {

  Future<List<Consultation>>? _futureConsultations;

  bool isButtonEnabled = false; // Set it to false to disable the button
  late int patientID;
  late int specialistID;
  late String specialistName;
  late String phone;
  int _currentIndex = 3;


  // String specialistName ="";
  // String specialistPhone ="";
  // String logStatus = "OFFLINE";
  // String clinicName="";
  // String passwordSpecialist = "";
  // String specialistTitle = "";

  String consultationStatus = "";
  DateTime? dateTime;


  @override
  void initState() {
    specialistID = widget.specialistID;
    phone = widget.phone;
    specialistName = widget.specialistName;
    _fetchConsultations();

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
                    future: _futureConsultations,
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

                              return Card(
                                child: InkWell(
                                  onTap: () {
                                     _showConsultationDetailsDialog(
                                         context, consultation);
                                  },

                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 700,
                                          height: 130,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${consultation.patientName}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5), // Adjust the height if needed
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Date: ${DateFormat('dd/MM/yyyy').format(consultation.consultationDateTime)}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Time: ${DateFormat('hh:mm a').format(consultation.consultationDateTime)}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top:5.0),
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
                                              ],
                                            ),


                                          ),
                                        )
                                      ],
                                    ),
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             MedicalRecordScreen(patientID: patientID)));
          } else if (index == 1) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => viewSpecialistScreen(patientID: patientID,)));
          } else if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SpecialistHomePage(specialistID: specialistID, phone: phone, specialistName: '',)));          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewUpcomingAppointmentforSpecialistSide(specialistID: specialistID,
                    specialistName: specialistName,
                    phone: phone,)));
          } else if (index == 4) {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => SettingsScreen(patientID: patientID,)));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'EMR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'TeleMedicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'View Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.grey[700],
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
      ),
    );


  }

  Future<void> _fetchConsultations() async {
    setState(() {
      _futureConsultations = viewUpcomingAppointmentforSpecialist(specialistID);
    });
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


  Future<List<Consultation>> viewUpcomingAppointmentforSpecialist(
      int patientID) async {
    Consultation consultation = Consultation(
      patientID: 0,
      consultationDateTime: DateTime.now(),
      specialistID: specialistID,
      consultationStatus: '',
    );
    print("okkk");

    // print(Specialist.viewSpecialistforPatientSide());
    return await Consultation.viewUpcomingAppointmentforSpecialistSide(specialistID);
  }

  void _showConsultationDetailsDialog(BuildContext context,
      Consultation consultation) {

    bool isApproved = consultation.consultationStatus == 'Accepted';
    bool isDecline = false;



    Future<void> _handleApproval(BuildContext context, Consultation consultation) async {
      // Check if the consultation status is 'Pending'
      if (consultation.consultationStatus == 'Pending') {
        // Show confirmation dialog
        bool confirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Accept Appointment'),
            content: Text('Are you sure you want to accept this request?'),
            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // User canceled
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // User confirmed
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        );

        if (confirmed) {
          final consultationID = consultation.consultationID;
          print("coid${consultation.consultationID}");
          final newStatus = 'Accepted';

          // Call the updateConsultationStatus method from the model
          bool success = await Consultation.updateConsultationStatus(int.parse(consultation.consultationID.toString()), newStatus);

          if (success) {
            print('Status updated successfully');

            // Update the UI with the new status
            consultation.consultationStatus = newStatus;

            // Close the existing dialog
            Navigator.pop(context);

            // Show the updated consultation details dialog
            _fetchConsultations(); // Refresh consultation data
            _showConsultationDetailsDialog(context, consultation);
          } else {
            print('Failed to update consultation status');
          }
        }
      }
    }





    Future<void> _handleDecline() async {

        // Show confirmation dialog
        bool confirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Decline Appointment'),
            content: Text('Are you sure you want to decline this request?'),
            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // User canceled
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // User confirmed
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        );

        if (confirmed) {
          final consultationID = consultation.consultationID;
          print("coid${consultation.consultationID}");
          final newStatus = 'Decline';

          // Call the updateConsultationStatus method from the model
          bool success = await Consultation.updateConsultationStatus(int.parse(consultation.consultationID.toString()), newStatus);

          if (success) {
            print('Status updated successfully');

            // Update the UI with the new status
            consultation.consultationStatus = newStatus;

            // Close the existing dialog
            Navigator.pop(context);
            _fetchConsultations(); // Refresh consultation data

            // Show the updated consultation details dialog
            _showConsultationDetailsDialog(context, consultation);
          } else {
            print('Failed to update consultation status');
          }
        }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Determine the text color based on the consultation status
            Color statusTextColor;
            switch (consultation.consultationStatus) {
              case 'Decline':
                statusTextColor = Colors.red;
                break;
              case 'Accepted':
                statusTextColor = hexColor("00A36C");
                break;
              case 'Pending':
                statusTextColor = hexColor("FFC000");
                break;
              default:
                statusTextColor = Colors.black;
            }

            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Appointment Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height:30,
                            child: Text(
                              ' ${consultation.patientName}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          SizedBox(height: 20,
                            child: Text(
                              'Date: ${DateFormat('dd/MM/yyyy').
                              format(consultation.consultationDateTime)}',
                            ),
                          ),
                          SizedBox(height: 20,
                            child: Text(
                              'Time: ${DateFormat('hh:mm a').
                              format(consultation.consultationDateTime)}',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Status: ${consultation.consultationStatus}',
                              style: TextStyle(
                                color: statusTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),



                          SizedBox(height: 16),

                          if (consultation.consultationStatus != 'Decline')
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: 280,
                                height:40,// Set the width to your desired value
                                child: ElevatedButton(
                                  onPressed: ()
            {

              _handleApproval(context, consultation);
            },
                                  style: ButtonStyle(
                                    backgroundColor: isApproved
                                        ? MaterialStateProperty.all(Colors.grey)
                                        : MaterialStateProperty.all(Colors.green),
                                    shape: MaterialStateProperty.all
                                    <RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                      ),
                                    ),
                                  ),
                                  child: Text('Approve'),
                                ),
                              ),
                            ),





                          if (consultation.consultationStatus != 'Decline')
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isDecline = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: hexColor("C73B3B") ,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),

                                    child: Text('Decline'),
                                  ),
                                ),
                              ),
                            ),

                          if (isApproved && consultation.consultationStatus
                              == 'Pending'&&
                              consultation.consultationStatus != 'Accepted' )
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Are you sure you want to call now?'),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        isApproved = true;

                                        Navigator.pop(context);
                                      },
                                      child: Text('Confirm Call'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {

                                        setState(() {
                                          isApproved = false;
                                        });
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          if (isDecline)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Are you sure you want to decline '
                                        'this appointment?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _handleDecline();
                                          setState(() {

                                          });

                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(0.0),
                                          ),
                                        ),
                                        child: Text('Confirm Decline'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isDecline = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                        ),
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                        ],
                      ),
                    )
                  ],
                )
            );
          },
        );
      },

    );
  }

}



