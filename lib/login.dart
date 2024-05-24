import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/register.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'Patient/forgotPasswordScreen.dart';
import 'Patient/patientHomePage.dart';
import 'Specialist/specialistHomePage.dart';
import 'ZegoCloud_VideoCall/common.dart';
import 'main.dart';


void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  bool _obscureText= true;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context)
  {
   return Scaffold(
     body:SingleChildScrollView(
       child: Column(
           children: [

   //-------------This is for logo image part-------
       Padding(
       padding: const EdgeInsets.only(top: 10.0),
       child: Column(
         children: [
           Image.asset(
             "assets/img.png",
             width: 280,
             height: 350,
           ),
         ],
       ),
   ),


   //---------This is for "WelcomeBack Part ----------
             Padding( padding: const EdgeInsets.only( left: 15.0, bottom: 10.0),
                 child:
                 Row(
                     children: <Widget> [
                       Text('Welcome Back,',
                         style: TextStyle(decoration: TextDecoration.none,
                             fontSize: 25.0,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w700),),
                     ]
                 )
             ),

            //---------This is for phone number text field ---------
             Container(
                 padding: EdgeInsets.all(20),
                 child: Column(  //column untuk letak icon and textfield
                   children: [
                     TextField(
                       controller: phoneController,
                       decoration: InputDecoration(
                         labelText: 'Phone Number',
                         prefixIcon: Icon(Icons.phone),
                         border: MyApp.loginInputBorder(),
                         enabledBorder: MyApp.loginInputBorder(),
                         focusedBorder: MyApp.loginFocusedBorder(),
                       ) ,
                       keyboardType: TextInputType.phone,//keyboardType: TextInputType.phone,
                     )
                   ],
                 )
             ),


            //------------This is for password textfield container---------
             Container(
                 padding: EdgeInsets.all(20),
                 child: Column(  //column untuk letak icon and textfield
                   children: [
                     TextField(
                       controller: passwordController,
                       decoration: InputDecoration(
                         labelText: 'Password',
                         prefixIcon: Icon(Icons.lock),
                         suffixIcon: GestureDetector(onTap: (){
                           setState(() {
                             _obscureText=!_obscureText;
                           });

                         },
                           child:Icon(!_obscureText ?Icons.visibility:
                           Icons.visibility_off),
                         ),
                         border:MyApp.loginInputBorder(),
                         enabledBorder: MyApp.loginInputBorder(),
                         focusedBorder: MyApp.loginFocusedBorder(),
                       ) ,
                       obscureText: _obscureText,
                     )

                   ],
                 )
             ),



             SizedBox(
               width:260,
               height: 45,
               child: ElevatedButton(
                 onPressed: () {
                   login();
                 },
                 style: ElevatedButton.styleFrom(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                   ),
                   backgroundColor: Color(MyApp.hexColor('C73B3B')), // Set your preferred background color
                 ),
                 child: Text('Login',
                   style:TextStyle(
                     color: Colors.white,
                     fontFamily: 'Inter',
                     fontWeight: FontWeight.w700,
                     fontSize: 15,
                   ),
                 ),
               ),
             ),


             GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) =>forgotPasswordScreen(),
                   ),
                 ); // go to register screen
               },
               child: Column(
                 children: [
                   SizedBox(height: 16),
                   Text(
                     'Forgot Password?',
                     style: TextStyle(
                       color: Color(MyApp.hexColor('#024362')),
                       fontFamily: 'Inter',
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                 ],
               ),
             ),



             SizedBox(height: 16),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 SizedBox(),
                 Text(
                   "Don't have account yet? ",
                   style: TextStyle(
                     color: Colors.grey,
                     fontFamily: 'Inter',
                     fontWeight: FontWeight.w700,
                   ),
                 ),

                 GestureDetector(
                   onTap: () {
                     setState(() {
                       Navigator.push(context, MaterialPageRoute(builder:
                           (context) => RegisterScreen(),)); //go to register screen
                     });
                   },
                   child: Text(
                     'Register Now',
                     style: TextStyle(
                       color: Color(
                         MyApp.hexColor('#C73B3B'),
                       ),
                       fontFamily: 'Inter',
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                 ),
               ],
             ),




    ],
       ),
     ),
    );
  }




  Future login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      print("tak dapat sini");

      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Null Information'),
              content: const Text('Both textfield cannot be null'),
              actions: [
                TextButton(child:
                const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },)
              ],
            );
          });
    }
    else {
      print("dapat");
      var url = Uri.http(
          MyApp.ipAddress, '/mediplexity/login.php', {'q': '{http}'});

      try {
        var response = await http.post(url, body: {
          "phone": phoneController.text,
          "password": passwordController.text,
        });

        var data = json.decode(response.body);
        print(data);
        if (data["status"] == "success patients" ) {

          print("success patient");
          // Login successful for patient, extract patient name

          String patientName = data["patientName"];
          int patientID = int.tryParse(data["patientID"]) ?? 0;
          print(patientID);

          final SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("phone", phoneController.text);
          await pref.setString("password", passwordController.text);
          await pref.setString("patientName", patientName);
          await pref.setInt("patientID", patientID);


          Fluttertoast.showToast(
            msg: "Hello, $patientName",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue, // You can customize the color
            textColor: Colors.white,
            fontSize: 16.0,
          );

          ZegoUIKitPrebuiltCallInvitationService().init(
              appID: MyApp.appID /*input your AppID*/,
              appSign:  MyApp.appSign,
              userID:  patientID.toString(),
              userName: patientName,
              notifyWhenAppRunningInBackgroundOrQuit: true,
              androidNotificationConfig: ZegoAndroidNotificationConfig(
                channelID: "nanti tengok balik",
                channelName: "Call Notification",
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

              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(phone: phoneController.text, patientName: patientName, patientID: patientID,),

            ),
          );
          setState(() {
            phoneController.clear();
            passwordController.clear();
          });
        } else if (data["status"] == "success specialist") {
          print("doctor masuk");


          String specialistName = data["specialistName"];
          int specialistID = int.parse(data["specialistID"]);
          String logStatus = data["logStatus"] ?? 'OFFLINE'; // Use null-aware operator


          final SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("phone", phoneController.text);
          await pref.setString("password", passwordController.text);
          await pref.setString("specialistName", specialistName);
          await pref.setInt("specialistID", specialistID);
          await pref.setString("logStatus", logStatus);


          ZegoUIKitPrebuiltCallInvitationService().init(
            appID: MyApp.appID /*input your AppID*/,
            appSign:  MyApp.appSign,
            userID:  specialistID.toString(),
            userName: specialistName,
            notifyWhenAppRunningInBackgroundOrQuit: true,
            androidNotificationConfig: ZegoAndroidNotificationConfig(
              channelID: "nanti tengok balik",
              channelName: "Call Notification",
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
          
          Fluttertoast.showToast(
            msg: "Hello, $specialistName",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.blue, // You can customize the color
            textColor: Colors.white,
            fontSize: 16.0,
          );


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecialistHomePage(
                phone: phoneController.text,
                specialistName: specialistName, specialistID: specialistID,),

            ),
          );

          setState(() {

          });
          //
          // phoneController.clear();
          // passwordController.clear();
        }
        else {
          print("tah la");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Login Failed'),
                content: const Text('Invalid username or password'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      } catch (error) {
        print("Error: $error");
        print("Error type: ${error.runtimeType}");

        String errorMessage;
        String title = 'Login Failed';

        if (error is http.ClientException) {
          errorMessage = 'Invalid username or password';
        } else if (error.toString().contains("type 'String' is not a subtype of type 'int' of 'index'")) {
          errorMessage = 'Wrong phone or password';
        } else {
          errorMessage = 'An error occurred while processing your request.';
        }

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }

    }
  }







/*
  when user click the specific textfield,
  the colour of the border will change
 */



}

class ZegoCallInvitationNotificationConfig {
}




