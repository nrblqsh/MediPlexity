//
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// import '../../Controller/requestController.dart';
//
// void main() {
//   runApp(MedicineRecommender());
// }
//
// class MedicineRecommender extends StatelessWidget {
//   const MedicineRecommender({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter with Flask',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FetchDataPage(),
//     );
//   }
// }
//
// class FetchDataPage extends StatefulWidget {
//   const FetchDataPage({Key? key}) : super(key: key);
//
//   @override
//   _FetchDataPageState createState() => _FetchDataPageState();
// }
//
// class _FetchDataPageState extends State<FetchDataPage> {
//   String? data;
//   List<String> symptomsList = [];
//   List<String> selectedSymptoms = [];
//   TextEditingController _symptomsController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSymptoms();
//   }
//
//   Future<void> fetchSymptoms() async {
//     RequestController requestController = RequestController(path: ':8000/symptoms');
//
//     await requestController.get(); // Assuming you have a get method in your RequestController
//
//     if (requestController.status() == 200) {
//       setState(() {
//         symptomsList = List<String>.from(requestController.result()['symptoms']);
//       });
//     } else {
//       throw Exception('Failed to load symptoms: ${requestController.status()}');
//     }
//   }
//
//   @override
//   void dispose() {
//     _symptomsController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchData() async {
//     RequestController requestController = RequestController(path: ':8000/test');
//
//     requestController.setBody({'symptoms': selectedSymptoms});
//
//     await requestController.post();
//
//     if (requestController.status() == 200) {
//       setState(() {
//         data = requestController.result().toString();
//       });
//     } else {
//       print('Failed to fetch data: ${requestController.status()}');
//     }
//   }
//
//   void addSymptom(String symptom) {
//     setState(() {
//       if (!selectedSymptoms.contains(symptom)) {
//         selectedSymptoms.add(symptom);
//       }
//
//     });
//   }
//
//   void removeSymptom(String symptom) {
//     setState(() {
//       selectedSymptoms.remove(symptom);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fetch Data from Flask'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("While our AI prediction is advanced, please note that it may not be 100% accurate. For more comprehensive information or medical advice, we recommend consulting a healthcare professional."),
//         TypeAheadField(
//               itemBuilder: (context, String suggestion) {
//                 return ListTile(
//                   title: Text(suggestion),
//                 );
//               },
//               onSelected: (String suggestion) {
//                 addSymptom(suggestion);
//                 _symptomsController.clear();
//                // _symptomsController.text = suggestion;
//               },
//           suggestionsCallback: (pattern) async {
//               return symptomsList.where((symptom) => symptom.toLowerCase().contains(pattern.toLowerCase())).toList();
//             },
//
//             ),
//             SizedBox(height: 20),
//             Wrap(
//               children: selectedSymptoms.map((symptom) {
//                 return Chip(
//                   label: Text(symptom),
//                   onDeleted: () {
//                     removeSymptom(symptom);
//                   },
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 fetchData();
//               },
//               child: Text('Predict'),
//             ),
//             SizedBox(height: 20),
//             data != null
//                 ? Text(data!)
//                 : CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/requestController.dart';

void main() {
  runApp(MedicineRecommender());
}

class MedicineRecommender extends StatelessWidget {
  const MedicineRecommender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter with Flask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FetchDataPage(),
    );
  }
}

class FetchDataPage extends StatefulWidget {
  const FetchDataPage({Key? key}) : super(key: key);

  @override
  _FetchDataPageState createState() => _FetchDataPageState();
}

class _FetchDataPageState extends State<FetchDataPage> {
  String? data;
  List<String> symptomsList = [];
  List<String> selectedSymptoms = [];
  TextEditingController _symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSymptoms();
  }

  Future<void> fetchSymptoms() async {
    RequestController requestController = RequestController(path: ':8000/symptoms');

    await requestController.get(); // Assuming you have a get method in your RequestController

    if (requestController.status() == 200) {
      setState(() {
        symptomsList = List<String>.from(requestController.result()['symptoms']);
      });
    } else {
      throw Exception('Failed to load symptoms: ${requestController.status()}');
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    RequestController requestController = RequestController(path: ':8000/test');

    requestController.setBody({'symptoms': selectedSymptoms});

    await requestController.post();

    if (requestController.status() == 200) {
      setState(() {
        data = jsonEncode(requestController.result());
      });
    } else {
      print('Failed to fetch data: ${requestController.status()}');
    }
  }

  void addSymptom(String symptom) {
    setState(() {
      if (!selectedSymptoms.contains(symptom)) {
        selectedSymptoms.add(symptom);
      }

    });
  }

  void removeSymptom(String symptom) {
    setState(() {
      selectedSymptoms.remove(symptom);
    });
  }
  void clearAll() {
    setState(() {
      selectedSymptoms.clear(); // Clear selected symptoms
      data = null; // Clear fetched data
    });
  }
  void checkUnknownSymptoms(BuildContext context) {
    List<String> unknownSymptoms = selectedSymptoms.where((symptom) => !symptomsList.contains(symptom)).toList();
    if (unknownSymptoms.isNotEmpty && unknownSymptoms==null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Unknown Symptoms"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The following symptoms are not recognized:"),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: unknownSymptoms.map((symptom) {
                    return Text("- $symptom");
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      fetchData();
    }
  }


Widget buildPointForm(String title, List<String> items) {
    return Container(
      width:350,
      margin: EdgeInsets.symmetric(vertical: 10.0), // Add margin for separation between forms
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5), // Add some space between the title and items
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text('➤ $item'),
          )).toList(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> resultData = data != null ? jsonDecode(data!) : {};

    List<String> symptoms = resultData['symptoms'] != null ? List<String>.from(resultData['symptoms']) : [];
    List<String> diets = resultData['diets'] != null ? List<String>.from(resultData['diets'][0].split(',')) : [];
    List<String> precautions = resultData['precautions'] != null ? List<String>.from(resultData['precautions'][0]) : [];
    List<String> workouts = resultData['workouts'] != null ? List<String>.from(resultData['workouts']) : [];

    return Scaffold(
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
      body:  SingleChildScrollView(
          padding: EdgeInsets.only(left: 5.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,// Align items to the top
            children: <Widget>[




              Padding(
                padding:
                const EdgeInsets.only(left: 10, top: 10, right: 20),
                child: Text(
                  "Enter your symptoms ",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
        Padding(
          padding:
          const EdgeInsets.only(left: 10, top: 10, right: 20),
          child: Text(
            "While our AI prediction is advanced, please note that it may not be 100% accurate."
                " For more comprehensive information or medical advice, we recommend consulting our healthcare professional.",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
          child: Text(
            "Let's get started! ",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),

              Container(
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,

                  children:[ Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TypeAheadField(
                      controller: _symptomsController, // Add this line
                      itemBuilder: (context, String suggestion) {
                        return ListTile(
                          title: Text(suggestion),

                        );
                      },
                      onSelected: (String suggestion) {
                        addSymptom(suggestion);
                        _symptomsController.clear();
                      },
                      suggestionsCallback: (pattern) async {
                        return symptomsList.where((symptom) => symptom.toLowerCase().contains(pattern.toLowerCase())).toList();
                      },
                    ),
                  ),
                    Positioned(
                      left: 15.0,
                      child: _symptomsController.text.isNotEmpty
                          ? Text(
                        '',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                          : Text(""),
                    ),
      ],
                ),

              ),
              SizedBox(height: 20),
              Wrap(
                children: selectedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom),
                    onDeleted: () {
                      removeSymptom(symptom);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   selectedSymptoms.clear(); // Clear the selectedSymptoms list
                      //   _symptomsController.clear(); // Clear the _symptomsController
                      // });
                      clearAll();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Set the background color to red
                    ),
                    child: Text('Clear',
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                  onPressed: () {
                    checkUnknownSymptoms(context);

                  },
                  child: Text('Predict'),
                ),
               



                ],
              ),
              SizedBox(height: 20),
              data != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildPointForm('Symptoms', symptoms),
                  buildPointForm('Diets', diets),
                  buildPointForm('Precautions', precautions),
                  buildPointForm('Workouts', workouts),
                ],
              )
                  : Text(""),
            ],
          ),
        ),

    );
  }
}

