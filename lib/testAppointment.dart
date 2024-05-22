// import 'package:flutter/material.dart';
// import 'package:omni_datetime_picker/omni_datetime_picker.dart';
//
//
// void main() {
//   runApp(
//     MaterialApp(
//       home: Directionality(
//         textDirection: TextDirection.ltr, // or TextDirection.rtl
//         child: DateTimePick(),
//       ),
//     ),
//   );
// }
//
// class DateTimePick extends StatefulWidget {
//   const DateTimePick({super.key});
//
//   @override
//   State<DateTimePick> createState() => _DateTimePickState();
// }
//
// class _DateTimePickState extends State<DateTimePick> {
//
//   showDatePicker() async{
//     DateTime? dateTime = await showOmniDateTimePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate:
//       DateTime(1600).subtract(const Duration(days: 3652)),
//       lastDate: DateTime.now().add(
//         const Duration(days: 3652),
//       ),
//       is24HourMode: false,
//       isShowSeconds: false,
//       minutesInterval: 1,
//       secondsInterval: 1,
//       borderRadius: const BorderRadius.all(Radius.circular(16)),
//       constraints: const BoxConstraints(
//         maxWidth: 350,
//         maxHeight: 650,
//       ),
//       transitionBuilder: (context, anim1, anim2, child) {
//         return FadeTransition(
//           opacity: anim1.drive(
//             Tween(
//               begin: 0,
//               end: 1,
//             ),
//           ),
//           child: child,
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 200),
//       barrierDismissible: true,
//       selectableDayPredicate: (dateTime) {
//         // Disable 25th Feb 2023
//         if (dateTime == DateTime(2023, 2, 25)) {
//           return false;
//         } else {
//           return true;
//         }
//       },
//     );
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:Text("Choose DateTime")
//       ),
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(onPressed: (){
//
//               showDatePicker();
//             },
//                 child: Text("DateTime Oicker")),
//
//
//           ],
//         ),
//       ),
//
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

void main() {
  runApp(
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr, // or TextDirection.rtl
        child: dateTime(),
      ),
    ),
  );
}

class dateTime extends StatelessWidget {
  const dateTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni DateTime Picker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  DateTime? dateTime = await showOmniDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), // Set firstDate to today

                    lastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    is24HourMode: false,
                    isShowSeconds: false,
                    minutesInterval: 1,
                    secondsInterval: 1,
                    isForce2Digits: true,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 650,
                    ),
                    transitionBuilder: (context, anim1, anim2, child) {
                      return FadeTransition(
                        opacity: anim1.drive(
                          Tween(
                            begin: 0,
                            end: 1,
                          ),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    selectableDayPredicate: (dateTime) {
                      // Disable 25th Feb 2023
                      if (dateTime == DateTime(2023, 2, 25)) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                  );

                  print("dateTime: $dateTime");
                },
                child: const Text("Show DateTime Picker"),
              ),



            ],
          ),
        ),
      ),
    );
  }
}