import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../Model/specialist.dart';
import '../../main.dart';


class viewClinicSpecialist extends StatefulWidget {
  final int clinicID;
  final int patientID;
  viewClinicSpecialist({required this.clinicID, required this.patientID});

  @override
  State<viewClinicSpecialist> createState() => _viewClinicSpecialistState();
}

class _viewClinicSpecialistState extends State<viewClinicSpecialist> {


  bool isButtonEnabled = false; // Set it to false to disable the button
  late int clinicID ;
  late int patientID;
  late int specialistID = 0;
  String specialistName ="";
  String specialistPhone ="";
  String logStatus = "OFFLINE";
  String clinicName="";
  String passwordSpecialist = "";
  String specialistTitle = "";


  @override
  void initState() {
    _loadData();
  }


  Future<void> _loadData() async {
     clinicID = widget.clinicID;
    print("clinic id is ${clinicID}");

     patientID = widget.patientID;
     print("patientID${patientID}");
    // Further processing...
  }




  @override
  Widget build(BuildContext context)
  {

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Text(
              "Find your specialist ",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
            child: Text(
              "Discover highly skilled healthcare experts for immediate "
                  "assistance with your health issues. Seek virtual consultations"
                  " with doctors through video calls or messaging ",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 200, bottom: 10),
            child: Text(
              "Let's get started! ",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
          ),

          Container(
            child: Expanded(
              child: FutureBuilder<List<Specialist>>(
                future: viewClinicSpecialistforPatientSide(clinicID), // Call fetchSpecialist() here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Specialist>? specialists = snapshot.data;
                    if (specialists != null && specialists.isNotEmpty) {
                      return ListView.builder(
                        itemCount: specialists.length,
                        itemBuilder: (BuildContext context, index) {
                          // Build each specialist profile here
                          Specialist specialist = specialists[index];


                          return GestureDetector(
                            onTap: () {
                              // Show a dialog or card with specialist details when clicked
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Display the specialist image
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(

                                            image: DecorationImage(
                                              image: NetworkImage(
                                                "http://${MyApp.ipAddress}/mediplexity/getSpecialistImagePatientSide.php?specialistID=${specialist.specialistID}}",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // Display the specialist name
                                        Text(
                                          '${specialist.specialistName}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 7,),
                                        Text(
                                          '${specialist.specialistTitle}',
                                          style: TextStyle(fontSize: 15, ),
                                        ),

                                        SizedBox(height: 20),
                                        Text(
                                          'You will need to wait until the specialist \n approve your request. '
                                              'Are you sure to \nproceed with your consultation request?',

                                          style: TextStyle(fontSize: 15, ),
                                        ),


                                        SizedBox(height: 25),
                                        if(specialist.logStatus == "OFFLINE")
                                          Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: isButtonEnabled ? () {
                                                  // Handle button press
                                                } : null, // Set onPressed to null if the button is disabled
                                                child: Text('Request Consultation Now'),
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5), // Set the border radius to 0 for straight edges
                                                    // You can adjust other properties of the border as needed
                                                    // side: BorderSide(color: Colors.red, width: 2), // Example of adding a border side
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              TextButton(
                                                onPressed: () {
                                                  // Handle button press
                                                },
                                                child: Text('Book for Later',
                                                  style: TextStyle(
                                                      color: Colors.white

                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      // Set the border radius to 0 for straight edges
                                                      // You can adjust other properties of the border as needed
                                                      // side: BorderSide(color: Colors.red, width: 2), // Example of adding a border side
                                                    ),
                                                    backgroundColor: Color(MyApp.hexColor('#FF0000'))
                                                ),
                                              ),
                                            ],
                                          ),
                                        if(specialist.logStatus == "ONLINE")
                                          Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  // Handle button press
                                                },
                                                child: Text('Request Consultation Now',
                                                  style: TextStyle(
                                                      color: Colors.white

                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      // Set the border radius to 0 for straight edges
                                                      // You can adjust other properties of the border as needed
                                                      // side: BorderSide(color: Colors.red, width: 2), // Example of adding a border side
                                                    ),
                                                    backgroundColor: Color(MyApp.hexColor('#FF0000'))
                                                ),
                                              ),
                                              SizedBox(height: 10,),

                                              TextButton(
                                                onPressed: () {
                                                  // Handle button press
                                                },
                                                child: Text('Book for Later',
                                                  style: TextStyle(
                                                      color: Colors.white

                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      // Set the border radius to 0 for straight edges
                                                      // You can adjust other properties of the border as needed
                                                      // side: BorderSide(color: Colors.red, width: 2), // Example of adding a border side
                                                    ),
                                                    backgroundColor: Color(MyApp.hexColor('#FF0000'))
                                                ),
                                              ),
                                            ],
                                          ),







                                        // Display more specialist details if needed
                                      ],

                                    ),



                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                        },
                                        child: Text(''),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(

                                      width: 50, // Adjust the width as needed
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: Colors.blue, width: 2), // Border properties

                                      ),// Adjust the height as needed

                                      child: Image.network(
                                        "http://${MyApp.ipAddress}/mediplexity/getSpecialistImagePatientSide.php?specialistID=${specialist.specialistID}}",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,

                                      ),// Placeholder color
                                      // Replace the color with the image once you have the image URL
                                      // You can use Image.network() for loading images from URLs
                                      // child: Image.network(specialist.imageUrl),
                                    ),
                                  ),
                                  // SizedBox(width: 10), // Add some space between the image and the text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left:15.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${specialist.specialistName}',
                                                style: TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              _buildOnlineIndicator(specialist.logStatus),
                                              SizedBox(width: 8),
                                            ],
                                          ),
                                          //
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, bottom: 15.0),
                                          child: Text(
                                            '${specialist.specialistTitle}',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                      ],
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
          )


        ],
      ),




    );
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


  Future<List<Specialist>> viewClinicSpecialistforPatientSide(int clinicID) async {
    Specialist specialist = Specialist(
        specialistID: specialistID,
        clinicID: clinicID,
        specialistName: specialistName,
        specialistTitle: specialistTitle,
        phone: specialistPhone,
        password: passwordSpecialist,
        logStatus: logStatus,
        clinicName: clinicName);
    print("okkk");
    print(clinicID);
    // print(Specialist.viewSpecialistforPatientSide());
    return await Specialist.viewClinicSpecialistforPatientSide(clinicID);



  }

}
