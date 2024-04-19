import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginScreen(),
    );
  }



  static int hexColor(String color)
  {
    String newColor = '0xff' + color;
    newColor= newColor.replaceAll('#', '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  static OutlineInputBorder loginFocusedBorder()
  {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(20)),
        borderSide: BorderSide(color:Color(
            MyApp.hexColor('#024362')),
            width: 3)
    );
  }

  static OutlineInputBorder loginInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.grey, width:3,),

    );
  }


}
