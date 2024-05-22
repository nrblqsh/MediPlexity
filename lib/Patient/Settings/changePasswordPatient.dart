import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/patient.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../patientHomePage.dart';


void main() {
  runApp(const MaterialApp(
    home: ChangePasswordScreen(patientID: 1,),
  ));
}

class ChangePasswordScreen extends StatefulWidget {
  final int patientID;
  const ChangePasswordScreen({required this.patientID});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  bool _isOldPasswordVisible = true;
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  bool _isPasswordEightCharacters = false;
  bool _havePasswordConstraints = false;
  bool _passwordTotalConstraints = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPhoneNumberExist = false;

  late int patientID;

  @override
  void initState() {
    super.initState();
    _getPatientID();
  }

  Future<void> _getPatientID() async {
   patientID = widget.patientID;
  }

  Future<void> updatePassword() async {
    try {


      // Call the updatePassword method from the Patient class
      List<Patient> updatedPatients = await Patient.updatePassword(
        patientID,
        oldPasswordController.text,
        newPasswordController.text,
      );

      // Check if the update was successful
      if (updatedPatients.isNotEmpty) {
        // Password updated successfully, perform navigation or show message
        setState(() {
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        });

        Fluttertoast.showToast(
          msg: "Password updated successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Perform navigation to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              phone: "phone",
              patientName: "patientName",
              patientID: patientID, // Replace with actual patientID
            ),
          ),
        );
      } else {
        // Handle case when password update fails
        showToastMessage('Failed to update password', Colors.red);
      }
    } catch (error) {
      print('Error updating password: $error');
    }
  }


  void showToastMessage(String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



  void onPasswordChanged(String password) {
    final numericRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) {
        _isPasswordEightCharacters = true;
      }

      _havePasswordConstraints = false;
      if (numericRegex.hasMatch(password)) {
        _havePasswordConstraints = true;
      }

      _passwordTotalConstraints = false;
      if (_isPasswordEightCharacters == true &&
          _havePasswordConstraints == true) {
        _passwordTotalConstraints = true;
      }
    });
  }


  void checkAndSave() {
    if (oldPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (newPasswordController.text == confirmPasswordController.text) {
        if (oldPasswordController.text == newPasswordController.text) {
          // Show AlertDialog if old password is the same as the new password
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Same Password Detected'),
                content: Text('Your old password is the same as the new password. Choose another password.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (!_passwordTotalConstraints) {
          // If requirements are not met, show an AlertDialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Password Requirements'),
                content: Text(
                    'Password must have at least 8 characters, including an uppercase letter, a lowercase letter, a digit, and a symbol.'
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Call the function to update the password
          updatePassword();
        }
      } else {
        showToastMessage('Passwords did not match', Colors.red);
      }
    } else {
      Fluttertoast.showToast(msg: 'No changes to update');
    }
  }



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
            "assets/MYTeleClinic.png",
            width: 594,
            height: 258,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 40.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Change Your Password',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 30.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 30.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Enter your new password',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [

                  SizedBox(
                    height:60,
                    child: TextField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                          child: Icon(!_isOldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: MyApp.loginInputBorder(),
                        enabledBorder: MyApp.loginInputBorder(),
                        focusedBorder: MyApp.loginFocusedBorder(),
                      ),
                      obscureText: _isOldPasswordVisible,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    onChanged: (password) {
                      onPasswordChanged(password);
                    },
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                        child: Icon(!_isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      border: MyApp.loginInputBorder(),
                      enabledBorder: MyApp.loginInputBorder(),
                      focusedBorder: MyApp.loginFocusedBorder(),
                    ),
                    obscureText: _isNewPasswordVisible,
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _isPasswordEightCharacters
                              ? Colors.green
                              : Colors.transparent,
                          border: _isPasswordEightCharacters
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15)),
                      ),
                      SizedBox(width: 10),
                      Text("Contains at least 8 characters")
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _havePasswordConstraints
                              ? Colors.green
                              : Colors.transparent,
                          border: _havePasswordConstraints
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                            child: Icon(Icons.check,
                                color: Colors.white, size: 15)),
                      ),
                      SizedBox(width: 9),
                      Text(
                          "At least 1 uppercase & lowercase, 1 digit, 1 symbol"),



                    ],
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Re-enter New Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                        child: Icon(!_isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      border: MyApp.loginInputBorder(),
                      enabledBorder: MyApp.loginInputBorder(),
                      focusedBorder: MyApp.loginFocusedBorder(),
                    ),
                    obscureText: _isConfirmPasswordVisible,
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 260,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  checkAndSave();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Color(MyApp.hexColor('C73B3B')),
                ),
                child: Text(
                  'Update Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



