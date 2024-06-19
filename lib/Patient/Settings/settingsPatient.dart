import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fyp/Patient/Telemedicine/viewUpcomingAppointmentforPatientSide.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../Model/patient.dart';
import '../../login.dart';
import '../Telemedicine/viewSpecialist.dart';
import '../e-MedicalRecord/eMedicalRecordOption.dart';
import '../patientHomePage.dart';
import 'editProfilePatient.dart';



class SettingsScreen extends StatefulWidget {
  final int patientID;
  final String patientName;
  final String phone;
  int _currentIndex = 4;


  SettingsScreen({required this.patientID,
  required this.patientName,
  required this.phone});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int patientID;
  late String patientName;
  String? phoneNumber;
  late String phone;
  String name = " ";
  Uint8List? patientImage;


  final Patient _patients = Patient(
    patientID: 0, // You may need to set the correct specialist ID
    icNumber: '', // You may need to set the correct clinic ID
    patientName: '', // You may need to set the correct specialist name
    gender: '', // You may need to set the correct specialist title
    phone: '', // You may need to set the correct phone number
    password: '', // You may need to set the correct password
    birthDate: DateTime.now(), // You may need to set the correct log status
    patientImage: Uint8List(0), // Empty Uint8List for no image
  );


  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
  @override
  void initState() {
    _loadID();
    _loadPatientImage();
    _loadData();
  }

  ImageProvider<Object>? _getImageProvider() {
    if (_patients.patientImage != null && _patients.patientImage!.isNotEmpty) {
      return MemoryImage(_patients.patientImage!); // Display the existing image
    } else {
      return AssetImage('asset/profile image default.jpg');
    }
  }


  Future<void> _loadID() async {
    patientID = widget.patientID;
    phone= widget.phone;
    patientName = widget.patientName;

    List<Patient> patients = await Patient.loadAll(patientID);

    if (patients.isNotEmpty) {
      Patient firstPatient = patients.first;

      print("Raw JSON Data: ${firstPatient.toJson()}");



    } else {
      print('No patient data available');
    }
  }


  Future<void> _loadPatientImage() async {
    try {
      Uint8List? imageBytes = await Patient.getPatientImage(patientID);

      if (imageBytes != null && imageBytes.isNotEmpty) {
        setState(() {
          _patients.patientImage = imageBytes;
        });
      } else {
        print('Invalid or empty image data');
      }
    } catch (e) {
      print('Error loading specialist image: $e');
    }
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedSpecialistID = prefs.getInt("specialistID") ?? 0;
    String storedPhone = prefs.getString("phone") ?? "";
    String storedName = prefs.getString("patientName") ?? "";

    setState(() {
      name = storedName;
      phone = storedPhone;
    });

  }

  // Future<void> _loadInfo() async {
  //   try {
  //     // Replace the following line with your actual code to load the patient name
  //
  //     setState(() {
  //
  //       patientName = _patients.patientName;
  //       print("patient name wehh $patientName");
  //
  //       phoneNumber = _patients.phone;
  //       print("phoneee$phoneNumber");
  //
  //     });
  //   } catch (e) {
  //     print('Error loading patient name: $e');
  //   }
  // }


  Widget settings(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: EdgeInsets.only(left: 15, right: 20, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // You can add your own custom icon here if needed
                Icon(
                  Icons.navigate_next_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget general(String label, VoidCallback onTap, List<GeneralItem> generalItems) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: EdgeInsets.only(left: 15, right: 20, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // You can add your own custom icon here if needed
                Icon(
                  Icons.navigate_next_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex =4;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,

          title: Center(
            child: Image.asset(
              "asset/MYTeleClinic.png",
              width: 594,
              height: 258,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        key: UniqueKey(), // Add this line
                        radius: 45,
                        backgroundImage: _getImageProvider(),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(top:25.0, left: 20),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  patientName?.isEmpty ?? true ? name : patientName!,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right:10.0),
                                child: Container(


                                  child: Text(
                                    phoneNumber?.isEmpty ?? true ? "+6$phone" :
                                    "+6$phoneNumber"!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 40.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'My account',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 30.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              settings('Edit Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile1(patientID: patientID,)),
                );
              }),
              settings('Change Password', () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => ChangePasswordScreen())
                // );
              }),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'General',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 30.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              general('Help Centre', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneralPage(
                      title: 'Help Center',
                      generalItems: [
                        GeneralItem(
                          question: 'How do I create an account?',
                          answer: 'To create an account, go to the Settings screen -> select "Create Account."',
                        ),
                        // Add more GeneralItem as needed
                        GeneralItem(
                          question: 'I forgot my password. What should I do?',
                          answer: 'If you forgot your password, you can use the'
                              ' "Forgot Password" feature on the login screen. '
                              'Follow the prompts to reset your password.',
                        ),
                        GeneralItem(
                          question: 'How can I contact support?',
                          answer: 'For support, please email us at '
                              'MyTeleClinic@UTeM.com.'
                              ' We will get back to you as soon as possible.',
                        ),
                      ],
                    ),
                  ),
                );
              }, [
                GeneralItem(
                  question: 'How do I create an account?',
                  answer: 'To create an account, go to the Settings screen -> select "Create Account."',
                ),
              ]),


              general('About Us', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneralPage(
                      title: 'About Us',
                      generalItems: [
                        GeneralItem(
                          question: 'Our Story',
                          // You can include an Image widget along with text
                          answer: 'We are group 16 from Faculty of Information Technology, UTeM, working on My TeleClinic.\n\n'
                              'My TeleClinic is a project aimed at providing a convenient and accessible platform for telemedicine services.\n\n '
                              'With a focus on leveraging technology to enhance healthcare, our team is dedicated to creating an innovative solution '
                              'that connects patients with healthcare professionals remotely.\n\n Through My TeleClinic, we aspire to improve healthcare '
                              'accessibility, reduce barriers to medical consultations, and ultimately contribute to the well-being of our community.',
                          // Replace with your image path
                        ),
                        // Add more GeneralItem as needed
                      ],
                    ),
                  ),
                );
              }, [
                GeneralItem(
                  question: 'How do I create an account?',
                  answer: 'To create an account, go to the Settings screen -> select "Create Account."',
                ),
              ]),

              general('Terms and Condition', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneralPage(
                      title: 'Terms and condition',
                      generalItems: [
                        GeneralItem(
                          question: 'User Registration',
                          // You can include an Image widget along with text
                          answer: "   - Register an account to use the App.\n"
                              "   - Provide accurate information during registration.\n"
                              "   - Maintain the confidentiality of your account.\n\n", // Replace with your image path
                        ),
                        GeneralItem(
                          question: 'Telemedicine Services',
                          // You can include an Image widget along with text
                          answer:   "   - Consult healthcare professionals remotely.\n"
                              "   - Not a substitute for in-person medical care.\n\n", // Replace with your image path
                        ),
                        GeneralItem(
                          question: 'Privacy Policy',
                          // You can include an Image widget along with text
                          answer:  "   - Your use is subject to our Privacy Policy.\n\n", // Replace with your image path
                        ),
                        GeneralItem(
                          question: 'Medical Advice',
                          // You can include an Image widget along with text
                          answer:  "   - Information is for informational purposes only.\n"
                              "   - Consult a qualified healthcare professional for advice.\n\n", // Replace with your image path
                        ),
                        GeneralItem(
                          question: 'Contact',
                          // You can include an Image widget along with text
                          answer:  "Contact us at myteleclinic@gmail.my\n\n", // Replace with your image path
                        ),
                        // Add more GeneralItem as needed
                      ],
                    ),
                  ),
                );
              }, [
                GeneralItem(
                  question: 'How do I create an account?',
                  answer: 'To create an account, go to the Settings screen -> select "Create Account."',
                ),
              ]),

              SizedBox(
                width: 260,
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.only(top: 17.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Log Out"),
                            content: Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  showSnackBar("Logged out successfully");
                                  ZegoUIKitPrebuiltCallInvitationService().uninit();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text("Log Out"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color(hexColor('C73B3B')),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                          MedicalRecordScreen(patientID: patientID, patientName: patientName,
                            phone: phone,
                          )));
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewSpecialistScreen(patientID: patientID,)));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(patientID: patientID, phone: '', patientName: '',)));
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
              label: 'View Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          backgroundColor: Colors.grey[700],
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
        )
    );
  }
}

class GeneralPage extends StatelessWidget {
  final String title;
  final List<GeneralItem> generalItems;

  const GeneralPage({
    required this.title,
    required this.generalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blue,
        ),
        title: Center(
          child: Image.asset(
            "asset/MYTeleClinic.png",
            width: 594,
            height: 258,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 16.0),
              children: generalItems.map((item) => GeneralItemTile(item)).toList(),
            ),
          ),
        ],
      ),

    );
  }
}

class GeneralItemTile extends StatelessWidget {
  final GeneralItem generalItem;

  const GeneralItemTile(this.generalItem);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        generalItem.question,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            generalItem.answer,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class GeneralItem {
  final String question;
  final String answer;

  const GeneralItem({
    required this.question,
    required this.answer,
  });
}

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blue,
        ),
        title: Center(
          child: Image.asset(
            "asset/MYTeleClinic.png",
            width: 594,
            height: 258,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10),
            child: Text(
              'Help Center',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 16.0),
              children: [
                FaqItem(
                  question: 'How do I create an account?',
                  answer: 'To create an account, go to the Settings screen ->'
                      ' select "Create Account.',
                ),
                FaqItem(
                  question: 'I forgot my password. What should I do?',
                  answer: 'If you forgot your password, you can use the'
                      ' "Forgot Password" feature on the login screen. '
                      'Follow the prompts to reset your password.',
                ),
                FaqItem(
                  question: 'How can I contact support?',
                  answer: 'For support, please email us at '
                      'MyTeleClinic@UTeM.com.'
                      ' We will get back to you as soon as possible.',
                ),
                // Add more FAQ items as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

int hexColor(String color) {
  String newColor = '0xff' + color;
  newColor = newColor.replaceAll('#', '');
  int finalColor = int.parse(newColor);
  return finalColor;
}