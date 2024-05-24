// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flip_panel_plus/flip_panel_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/main.dart';
import 'package:fyp/testHeartRate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:faker/faker.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../Model/consultation.dart';
import 'package:intl/intl.dart';

import '../ZegoCloud_VideoCall/common.dart';
import 'Telemedicine_Consultation/viewUpcomingAppointmentforSpecialistSide.dart';




class SpecialistHomePage extends StatefulWidget {
   String phone;
   String specialistName;
   int specialistID;

  SpecialistHomePage(
      {required this.phone,
        required this.specialistName,
        required this.specialistID});


  @override
  State<SpecialistHomePage> createState() => SpecialistHomePageState();
}

class SpecialistHomePageState extends State<SpecialistHomePage> {
  // late String phone; // To store the retrieved phone number
  late String phone; // To store the retrieved phone number
  late String specialistName;
  late int specialistID;





  int _currentIndex = 2;

  // Position? userLocation;


  @override
  void initState() {
    _loadData();
    //   getFCMToken(patientID); // Add this line to retrieve the FCM token
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      // child: ChangeNotifierProvider(
      //   create: (context) => CountdownProvider(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 72,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/MYTeleClinic.png",
                width: 594,
                height: 258,
              ),
            ],
          ),
        ),

        body:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Service",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        textStyle: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.star,
                      size: 24,
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 20), // Adjust padding as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: customIconWithLabel(
                            Icons.people_alt,
                            30,
                            Colors.white,
                            'Patient List',
                          ),
                          onTap: () {
                            // Navigate to patient list screen
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: customIconWithLabel(
                            Icons.assignment_outlined,
                            30,
                            Colors.white,
                            'Consultation\nHistory',
                          ),
                          onTap: () {
                            // Navigate to consultation history screen
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: customIconWithLabel(
                            Icons.calendar_month,
                            30,
                            Colors.white,
                            'Upcoming\nAppointment',
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewUpcomingAppointmentforSpecialistSide(

                                        specialistID: int.parse(specialistID.toString()),

                                      ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: 20,),




                          Row(
                            children: [
                              Text(
                                "Today's Appointment",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  textStyle: const TextStyle(
                                      fontSize: 22, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 80.0),
                      Container(
                        height: 800,
                        // Set width to take available space
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),

                        child: SingleChildScrollView(
                          child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        SizedBox(
                                         // width: 800,
                                          height: 800,
                                          child: FutureBuilder<List<Consultation>>(
                                            future: getTodayAppointmentforSpecialist(specialistID),
                                            builder: (BuildContext context, AsyncSnapshot<List<Consultation>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(child: CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(child: Text('Error: ${snapshot.error}'));
                                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                return Center(child: Text('No Data for Appointment Today'));
                                              } else if (snapshot.hasData) {
                                                List<Consultation>? consultations = snapshot.data;

                                                return ListView.builder(
                                                  itemCount: consultations?.length ?? 0,
                                                  itemBuilder: (BuildContext context, index) {
                                                    Consultation consult = consultations![index];
                                                    print("patienname ${consult.patientName}");
                                                    String? patientName = consult.patientName;
                                                    return Card(
                                                      elevation: 10,
                                                      margin: EdgeInsets.all(8.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                        side: BorderSide(color: Colors.blueAccent),
                                                      ),
                                                      child: SizedBox(
                                                        height: 150,

                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        '${consult.patientName}',
                                                                        style: TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 18,
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 3,),
                                                                      Text(
                                                                        '${DateFormat('dd/MM/yyyy').format(consult.consultationDateTime)}',
                                                                      ),
                                                                      SizedBox(height: 3,),
                                                                      Text(
                                                                        '${DateFormat('hh:mm a').format(consult.consultationDateTime)}',
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Container(
                                                                        height: 23,
                                                                        width: 75,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20),
                                                                          color: Color(_getStatusColor(consult.consultationStatus)),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            '${consult.consultationStatus}',
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                Container(
                                                                  width: 150,
                                                                  height: 200,// Adjust the width as needed
                                                                  child: Align(
                                                                    alignment: Alignment.bottomRight,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        if (consult.consultationStatus != 'Accepted' &&
                                                                            consult.consultationStatus != 'Decline'&&
                                                                            consult.consultationStatus != 'Done')
                                                                          Column(
                                                                            children: [
                                                                              IconButton(
                                                                                icon: Icon(Icons.cancel,
                                                                                  size: 30,
                                                                                  color: Colors.red,),
                                                                                onPressed: () async {
                                                                                  bool confirmed = await showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(10.0),
                                                                                        ),
                                                                                        title: Text('Confirm Decline'),
                                                                                        content: Text('Are you sure you want to decline this consultation?'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop(false);
                                                                                            },
                                                                                            child: Text('Cancel'),
                                                                                          ),
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop(true);
                                                                                            },
                                                                                            child: Text('Confirm'),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );

                                                                                  if (confirmed == true) {
                                                                                    try {
                                                                                      int consultationID = consult.consultationID ?? 0;

                                                                                      String newStatus = 'Decline';

                                                                                     bool success = await Consultation.updateConsultationStatus(int.parse(consultationID.toString()), newStatus);

                                                                                     if(success)
                                                                                       {
                                                                                         // Update the UI with the new status
                                                                                         consult.consultationStatus = newStatus;

                                                                                         // Close the existing dialog
                                                                                         setState(() {

                                                                                         });
                                                                                       }
                                                                                    } catch (e) {
                                                                                      print('Error updating status: $e');
                                                                                    }
                                                                                  }
                                                                                },
                                                                              ),
                                                                              Text('Decline',
                                                                                style: TextStyle(
                                                                                    fontWeight:
                                                                                    FontWeight.w400,
                                                                                    fontSize: 15
                                                                                ),),
                                                                            ],
                                                                          ),
                                                                        Spacer(),
                                                                        if (consult.consultationStatus == 'Accepted')
                                                                          Expanded(
                                                                            child: Column(
                                                                              children: [
                                                                                IconButton(
                                                                                  icon: Icon(Icons.add_ic_call_sharp,
                                                                                      size: 30,
                                                                                      color: Color(MyApp.hexColor("228B22"))),
                                                                                  onPressed: () async {
                                                                                    bool confirmed = await showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        return AlertDialog(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          title: Text('Confirm Call Patient'),
                                                                                          content: Text('Are you sure you want to call this patient?'),
                                                                                          actions: [

                                                                                            TextButton(
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop(false);
                                                                                              },
                                                                                              child: Text('Cancel'),
                                                                                            ),

                                                                                            TextButton(
                                                                                              onPressed: () async {

                                                                                                int? consultationID = consult.consultationID;
                                                                                                print("consullttt$consultationID");
                                                                                                // Check and request camera and microphone permissions
                                                                                                var statusCamera = await Permission.camera.request();
                                                                                                var statusMicrophone = await Permission.microphone.request();

                                                                                                if (statusCamera.isGranted && statusMicrophone.isGranted) {
                                                                                                  print("dapat");
                                                                                                  // Both camera and microphone permissions are granted
                                                                                                  Navigator.of(context).pop(true); // Close the dialog and return true
                                                                                                } else {
                                                                                                  // Permissions are not granted
                                                                                                  // Show a message to inform the user using a Dialog
                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text('Permission Required'),
                                                                                                        content: Text('Camera and microphone permissions are required to make a call.'),
                                                                                                        actions: [
                                                                                                          TextButton(
                                                                                                            onPressed: () {
                                                                                                              Navigator.of(context).pop(false);
                                                                                                            },
                                                                                                            child: Text('OK'),
                                                                                                          ),
                                                                                                        ],
                                                                                                      );
                                                                                                    },
                                                                                                  );
                                                                                                }
                                                                                              },
                                                                                              child: Text('Confirm'),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );

                                                                                    if (confirmed!= null && confirmed) {
                                                                                      try {
                                                                                       // actionButtion(true);
                                                                                        print("masuk");
                                                                                        sendCallButton(
                                                                                          patientID: "1",
                                                                                           patientName: consult.patientName.toString(),
                                                                                           // or false based on whether it's a video call or not
                                                                                          onCallFinished: (code, message, errorInvitees) {
                                                                                            // Handle call initiation result here
                                                                                            onSendCallInvitationFinished(code, message, errorInvitees);
                                                                                          },
                                                                                        );

                                                                                        print("test");
                                                                                      } catch (e) {
                                                                                        print('Error during sen: $e');
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                ),
                                                                                Text('Call Now'),
                                                                              ],
                                                                            ),
                                                                          ),


                                                                        if (consult.consultationStatus != 'Accepted' &&
                                                                            consult.consultationStatus != 'Decline' &&
                                                                            consult.consultationStatus != 'Done' &&
                                                                            consult.consultationStatus != 'Ready to Call'
                                                                        )
                                                                          Column(
                                                                            children: [
                                                                              IconButton(
                                                                                icon: Icon(Icons.done,
                                                                                  size: 35,
                                                                                  color: Colors.green,),
                                                                                onPressed: () async {
                                                                                  try {
                                                                                    int consultationID = consult.consultationID ?? 0;
                                                                                    String newStatus = 'Accepted';

                                                                                    bool success = await Consultation.updateConsultationStatus(int.parse(consultationID.toString()), newStatus);

                                                                                    if(success)
                                                                                    {
                                                                                      // Update the UI with the new status
                                                                                      consult.consultationStatus = newStatus;

                                                                                      // Close the existing dialog
                                                                                      setState(() {

                                                                                      });
                                                                                    }
                                                                                  } catch (e) {
                                                                                    print('Error updating status: $e');
                                                                                  }
                                                                                },
                                                                              ),
                                                                              Text('Accept',
                                                                                style: TextStyle
                                                                                  (fontWeight:
                                                                                FontWeight.w400,
                                                                                    fontSize: 15)
                                                                                ,
                                                                              ),
                                                                            ],
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
                                                return Center(child: Text('No data available'));
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ),
          ],
                              ),



          ),
                          ),
                        ),

                            );









  }


  Widget customIconWithLabel(
      IconData icon, double size, Color iconColor, String label) {
    int bgColor = MyApp.hexColor('A34040');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(bgColor),
         ),
            child: Icon(
              icon,
              size: size,
              color: iconColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            maxLines: null,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


  // Widget sendCallInvitationButton({
  //   required bool isVideoCall,
  //   required List<String> inviteeUserIDs,
  //   void Function(String code, String message, List<String> errorInvitees)? onCallFinished,
  // }) {
  //   // Convert list of user IDs to list of ZegoUIKitUser objects
  //   List<ZegoUIKitUser> invitees = inviteeUserIDs.map((userID) {
  //     return ZegoUIKitUser(id: userID, name: 'user_$userID');
  //   }).toList();
  //
  //   return ZegoSendCallInvitationButton(
  //     isVideoCall: isVideoCall,
  //     invitees: invitees,
  //     resourceID: "zego_data",
  //     iconSize: const Size(40, 40),
  //     buttonSize: const Size(50, 50),
  //     onPressed: onCallFinished, // Handle the result of sending the invitation
  //   );
  // }

  void onSendCallInvitationFinished(
      String code,
      String message,
      List<String> errorInvitees,
      ) {
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





  Future<void> _loadData() async {

    phone = widget.phone;
    specialistID = widget.specialistID;
    specialistName = widget.specialistName;

setState(() {
  print(phone);
  print("specialsitid ${specialistID}");
  print("specialis name ${specialistName}");
});


    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: MyApp.appID /*input your AppID*/,
      appSign:  MyApp.appSign,
      userID:  specialistID.toString(),
      userName: specialistName,
      notifyWhenAppRunningInBackgroundOrQuit: true,
      androidNotificationConfig: ZegoAndroidNotificationConfig(
        channelID: "zego_channel",
      //  channelName: "Call Notification",
        sound: "notification",
        icon: "notification_icon",
      ),
      plugins: [
        ZegoUIKitSignalingPlugin(),
      ],
      requireConfig: (ZegoCallInvitationData data)
      {
        final config = (data.invitees.length > 1)?ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config.avatarBuilder = customAvatarBuilder;
        config.topMenuBarConfig.isVisible = true;
        config.topMenuBarConfig.buttons.insert(0, ZegoMenuBarButtonName.minimizingButton);
        return config;
      },
    );

  }

  Future<List<Consultation>> getTodayAppointmentforSpecialist(
      int specialistID) async {
    Consultation consultation = Consultation(
      patientID: 0,
      consultationDateTime: DateTime.now(),
      specialistID: specialistID,
      consultationStatus: '',
    );
    print("okkk");

    // print(Specialist.viewSpecialistforPatientSide());
    return await Consultation.getTodayAppointmentforSpecialist(specialistID);
  }

  int _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green.value;
      case 'Decline':
        return Colors.red.value;
      case 'Pending':
      // Use your hexColor function here for the desired color
        return MyApp.hexColor('FFC000');
      case 'Done':
      // Use your hexColor function here for the desired color
        return MyApp.hexColor('024362');
      case 'Ready to Call': // Add a case for a custom color
        return MyApp.hexColor('1A2B3C'); // Replace with your custom hexadecimal color
      default:
        return Colors.transparent.value; // Default color
    }
  }





}
