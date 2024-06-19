// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flip_panel_plus/flip_panel_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
 import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:my_teleclinic/Patients/Profile/CountDown.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
 import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
 import 'package:http/http.dart' as http;
 import 'dart:convert';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../ZegoCloud_VideoCall/common.dart';
import '../main.dart';
import 'Map/viewMap.dart';
import 'Medicine_Recommender/medicine recommender.dart';
import 'Settings/editProfilePatient.dart';
import 'Settings/settingsPatient.dart';
import 'Telemedicine/viewSpecialist.dart';
import 'Telemedicine/viewUpcomingAppointmentforPatientSide.dart';
import 'e-MedicalRecord/eMedicalRecordOption.dart';
import 'e-MedicalRecord/patientVitalInfo/vitalInfoScreen.dart';


class HomePage extends StatefulWidget {
  final String phone;
  final String patientName;
  final int patientID;

  HomePage(
      {required this.phone,
        required this.patientName,
        required this.patientID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String phone; // To store the retrieved phone number
  late String patientName;
  late int patientID;

  int _currentIndex = 2;

  List<Widget> pages = [];

  Position? userLocation;


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

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Services",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          textStyle:
                          const TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        Icons.people_alt_sharp,
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8.0),
                      InkWell(
                        onTap: () async {
                          // Check and request camera and microphone permissions
                          var statusCamera = await Permission.camera.request();
                          var statusMicrophone = await Permission.microphone
                              .request();

                          if (statusCamera.isGranted && statusMicrophone
                              .isGranted) {
                            // String? callID = await getCallID(consultationID);
                            // if (callID != null) {
                            //   // Handle the case where the channel name is not null
                            //   print('callID: $callID');
                            //   print("tess$consultationID");
                            //   print(patientName);
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => MyCall(callID: callID,id:
                            //       patientID.toString(),
                            //         name: patientName,
                            //       roleId:0,
                            //           consultationID: consultationID),
                            //     ),
                            //   );
                            // } else {
                            //   // Handle the case where the channel name is null
                            //   print('Failed to get channel name from backend.');
                            // }

                          } else {
                            // Permissions not granted, show an alert or handle accordingly
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Permission Required'),
                                  content: Text(
                                      'Camera and microphone permissions are required for video calls.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 180),

                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           MedicalRecordScreen(patientID: patientID)),
                                  // );
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/1076/1076325.png",
                                      height: 64,
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "E-Medical\n Record",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            viewSpecialistScreen(
                                              patientID: patientID,)),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/5980/5980109.png",
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "TeleMedicine",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewUpcomingAppointmentforPatientSide(
                                              patientID: patientID,)),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678116-calendar-512.png",
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      "       View\n Appointment",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddVitalInfoScreen(
                                              patientID: patientID,)),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/1076/1076325.png",
                                      height: 64,
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "Vital Info \n Record",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MedicineRecommender()),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/5980/5980109.png",
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "Recommender",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                      MaterialPageRoute(builder: (context) => SettingsScreen(patientID: patientID, patientName: patientName,phone: phone,)));

                                },
                                child: Column(
                                  children: [
                                    Image.network(
                                      "https://cdn0.iconfinder.com/data/icons/small-n-flat/24/678116-calendar-512.png",
                                      width: 64,
                                      height: 64,
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      "      Edit profile",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Row(
                          children: [

                            Text(
                              "AI Health Assistant",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // SizedBox(width: 8.0),
                            Lottie.asset(
                              'assets/aiassistantanimation.json',
                              width: 70,
                              height: 55,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      // Container with FlipClockPlus.countdown

                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 2),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "Try our new AI-based health assistant! \n\nSimply enter your symptoms and receive personalized health advice and recommendations. ",
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                              ),

                              SizedBox(height: 10),
                              // Add some space between the text and the button
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 37,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MedicineRecommender()),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.navigate_next_outlined,
                                      color: Colors.white,
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

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Nearby Clinic",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(
                                fontSize: 22, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.location_pin,
                          size: 24,
                          color: Colors.red,
                        ),
                        SizedBox(height: 25.0),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  MapLocation(patientID: patientID,)),
                            );
                          },
                          child: Container(
                            height: 380,
                            width: 250,
                            margin: EdgeInsets.symmetric(vertical: 16.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Stack(
                              children: [
                                GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: userLocation != null
                                        ? LatLng(userLocation!.latitude,
                                        userLocation!.longitude)
                                        : const LatLng(
                                        2.3232303497978815, 102.29396072202006),
                                    zoom: 14,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MapLocation(
                                                  patientID: patientID)),
                                        );
                                        print("Button tapped!");
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(MyApp.hexColor("C73B3B"))),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Adjust the radius as needed
                                          ),
                                        ),
                                      ),
                                      child: Text("Navigate to Map Screen",
                                        style: TextStyle(color: Colors.white),),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MedicalRecordScreen(patientID: patientID, patientName: patientName, phone: phone,)));
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewSpecialistScreen(patientID: patientID,)));
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/menu');
            } else if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewUpcomingAppointmentforPatientSide(patientID: patientID,)));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(patientID: patientID, patientName: patientName,phone: phone,)));
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
      ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: currentPage,
        //   backgroundColor: Colors.blue,
        //   onTap: (value) {
        //     setState(() {
        //       currentPage = value;
        //     });
        //   },

        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "EMR"),
        //     BottomNavigationBarItem(icon: Icon(Icons.add), label: "Home"),
        //     BottomNavigationBarItem(icon: Icon(Icons.abc), label: "View Appointment"),
        //     BottomNavigationBarItem(icon: Icon(Icons.abc_outlined), label: "Settings"),
        //   ],
        // ),


      );

  }

  Future<void> _loadData() async {
    setState(() {
      phone = widget.phone;
      patientName = widget.patientName;
      patientID = widget.patientID;
    });

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: MyApp.appID /*input your AppID*/,
      appSign:  MyApp.appSign,
      userID:  patientID.toString(),
      userName: patientName,
      notifyWhenAppRunningInBackgroundOrQuit: true,
      androidNotificationConfig: ZegoAndroidNotificationConfig(
        channelID: "zego_channel",
       // channelName: "Call Notification",
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

    pages = [
      HomePage(patientID: patientID, phone: phone, patientName: patientName),
      viewSpecialistScreen(patientID: patientID,),
      viewSpecialistScreen(patientID: patientID,),
      viewSpecialistScreen(patientID: patientID,),

    ];
    //   print("apptpt$patientID");
    //
    //
    //   List<Consultation> consultations = await _fetchTodayConsultationsPatientSide(patientID);
    //
    //   print('Fetched Consultations: $consultations');
    //
    //
  }

  //
  //
  //
  //

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

  Future<void> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.denied) {
        print('Location permission denied');
      }
    }).onError((error, stackTrace) {
      print('error $error');
    });

    userLocation = await Geolocator.getCurrentPosition();
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
        return MyApp.hexColor(
            '1A2B3C'); // Replace with your custom hexadecimal color
      default:
        return Colors.transparent.value; // Default color
    }
  }
}