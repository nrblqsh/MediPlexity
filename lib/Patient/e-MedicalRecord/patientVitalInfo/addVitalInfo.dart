// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import '../../../Controller/requestController.dart';
// // import '../../../Model/vitalInfo.dart';
// // import 'package:fl_chart/fl_chart.dart';
// //
// // import 'chartVitalInfo.dart';
// //
// // //
// // //
// // // class AddPatientInfo extends StatefulWidget {
// // //   final int patientID;
// // //   final String attribute;
// // //   final String title;
// // //
// // //   AddPatientInfo({
// // //     required this.patientID,
// // //     required this.attribute,
// // //     required this.title,
// // //   });
// // //
// // //   @override
// // //   State<AddPatientInfo> createState() => _AddPatientInfoState();
// // // }
// // //
// // // class _AddPatientInfoState extends State<AddPatientInfo> {
// // //   late int patientID;
// // //   late String attribute;
// // //   late String title;
// // //
// // //   final TextEditingController _attributeController = TextEditingController();
// // //   bool _isLoading = false;
// // //   List<double> _chartData = []; // Variable to store chart data
// // //   List<String> _chartDates = []; // Variable to store chart dates
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     patientID = widget.patientID;
// // //     attribute = widget.attribute;
// // //     title = widget.title;
// // //     loadChartData();
// // //   }
// // //
// // //
// // //   Future<void> loadChartData() async {
// // //     setState(() {
// // //       _isLoading = true;
// // //     });
// // //
// // //     try {
// // //       List<double> attributeValues = [];
// // //       List<String> chartDates = [];
// // //
// // //       List<VitalInfo> vitalInfos =
// // //       await VitalInfo.getVitalInfoSpecificAttribute(patientID, attribute);
// // //       if (vitalInfos.isNotEmpty) {
// // //         for (var vitalInfo in vitalInfos) {
// // //           double? value;
// // //
// // //           switch (attribute) {
// // //             case 'weight':
// // //               value = vitalInfo.weight;
// // //               break;
// // //             case 'height':
// // //               value = vitalInfo.height;
// // //               break;
// // //             case 'waistCircumference':
// // //               value = vitalInfo.waistCircumference;
// // //               break;
// // //             case 'bloodPressure':
// // //               value = vitalInfo.bloodPressure;
// // //               break;
// // //             case 'bloodGlucose':
// // //               value = vitalInfo.bloodGlucose;
// // //               break;
// // //           }
// // //
// // //           if (value != null) {
// // //             // Ensure the value is a valid numeric string before parsing
// // //             double? parsedValue = double.tryParse(value.toString());
// // //             if (parsedValue != null) {
// // //               attributeValues.add(parsedValue);
// // //               chartDates.add(vitalInfo.latestDate); // Add date to chartDates
// // //             }
// // //           }
// // //         }
// // //
// // //         setState(() {
// // //           _chartData = attributeValues;
// // //           _chartDates = chartDates;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       print('Error loading attribute data: $e');
// // //     } finally {
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //     }
// // //   }
// // //
// // //
// // //
// // //   Future<void> saveInfo() async {
// // //     if (_attributeController.text.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Please enter $title')),
// // //       );
// // //       return;
// // //     }
// // //
// // //     setState(() {
// // //       _isLoading = true;
// // //     });
// // //
// // //     double? value = double.tryParse(_attributeController.text);
// // //     if (value == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Please enter a valid $title')),
// // //       );
// // //       setState(() {
// // //         _isLoading = false;
// // //       });
// // //       return;
// // //     }
// // //
// // //     // Create a VitalInfo instance and set the appropriate attribute
// // //     final vitalInfo = VitalInfo(
// // //       latestDate: DateTime.now().toIso8601String(),
// // //       patientID: patientID,
// // //     );
// // //
// // //     switch (attribute) {
// // //       case 'weight':
// // //         vitalInfo.weight = value;
// // //         break;
// // //       case 'height':
// // //         vitalInfo.height = value;
// // //         break;
// // //       case 'waistCircumference':
// // //         vitalInfo.waistCircumference = value;
// // //         break;
// // //       case 'bloodPressure':
// // //         vitalInfo.bloodPressure = value;
// // //         break;
// // //       case 'bloodGlucose':
// // //         vitalInfo.bloodGlucose = value;
// // //         break;
// // //       case 'heartRate':
// // //         vitalInfo.heartRate = value;
// // //         break;
// // //       default:
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(content: Text('Invalid attribute')),
// // //         );
// // //         setState(() {
// // //           _isLoading = false;
// // //         });
// // //         return;
// // //     }
// // //
// // //     final success = await vitalInfo.save(patientID);
// // //     if (success) {
// // //       print("dapat");
// // //     } else {
// // //       print("takdapat");
// // //     }
// // //
// // //     setState(() {
// // //       _isLoading = false;
// // //     });
// // //
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(content: Text(success ? '$title saved successfully' : 'Failed to save $title')),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Add Patient Weight', style: GoogleFonts.lato()),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Column(
// // //           children: [
// // //             TextField(
// // //               controller: _attributeController,
// // //               keyboardType: TextInputType.number,
// // //               decoration: InputDecoration(
// // //                 labelText: 'Enter ${title}',
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             _isLoading
// // //                 ? CircularProgressIndicator()
// // //                 : ElevatedButton(
// // //               onPressed: saveInfo,
// // //               child: Text('Save'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // class AddPatientInfo extends StatefulWidget {
// //   final int patientID;
// //   final String attribute;
// //   final String title;
// //
// //   AddPatientInfo({
// //     required this.patientID,
// //     required this.attribute,
// //     required this.title,
// //   });
// //
// //   @override
// //   State<AddPatientInfo> createState() => _AddPatientInfoState();
// // }
// //
// // class _AddPatientInfoState extends State<AddPatientInfo> {
// //   late int patientID;
// //   late String attribute;
// //   late String title;
// //
// //   final TextEditingController _attributeController = TextEditingController();
// //   bool _isLoading = false;
// //   List<double> _chartData = [];
// //   List<String> _chartDates = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     patientID = widget.patientID;
// //     attribute = widget.attribute;
// //     title = widget.title;
// //     loadChartData();
// //   }
// //
// //   Future<void> loadChartData() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       List<double> attributeValues = [];
// //       List<String> chartDates = [];
// //
// //       List<VitalInfo> vitalInfos =
// //       await VitalInfo.getVitalInfoSpecificAttribute(patientID, attribute);
// //       if (vitalInfos.isNotEmpty) {
// //         for (var vitalInfo in vitalInfos) {
// //           double? value;
// //
// //           switch (attribute) {
// //             case 'weight':
// //               value = vitalInfo.weight;
// //               break;
// //             case 'height':
// //               value = vitalInfo.height;
// //               break;
// //             case 'waistCircumference':
// //               value = vitalInfo.waistCircumference;
// //               break;
// //             case 'bloodPressure':
// //               value = vitalInfo.bloodPressure;
// //               break;
// //             case 'bloodGlucose':
// //               value = vitalInfo.bloodGlucose;
// //               break;
// //             case 'heartRate':
// //               value = vitalInfo.heartRate;
// //               break;
// //           }
// //
// //           if (value != null) {
// //             attributeValues.add(value);
// //             chartDates.add(vitalInfo.latestDate);
// //           }
// //         }
// //
// //         setState(() {
// //           _chartData = attributeValues;
// //           _chartDates = chartDates;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading attribute data: $e');
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> saveInfo() async {
// //     if (_attributeController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter $title')),
// //       );
// //       return;
// //     }
// //
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     double? value = double.tryParse(_attributeController.text);
// //     if (value == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter a valid $title')),
// //       );
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       return;
// //     }
// //
// //     final vitalInfo = VitalInfo(
// //       latestDate: DateTime.now().toIso8601String(),
// //       patientID: patientID,
// //     );
// //
// //     switch (attribute) {
// //       case 'weight':
// //         vitalInfo.weight = value;
// //         break;
// //       case 'height':
// //         vitalInfo.height = value;
// //         break;
// //       case 'waistCircumference':
// //         vitalInfo.waistCircumference = value;
// //         break;
// //       case 'bloodPressure':
// //         vitalInfo.bloodPressure = value;
// //         break;
// //       case 'bloodGlucose':
// //         vitalInfo.bloodGlucose = value;
// //         break;
// //       case 'heartRate':
// //         vitalInfo.heartRate = value;
// //         break;
// //       default:
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Invalid attribute')),
// //         );
// //         setState(() {
// //           _isLoading = false;
// //         });
// //         return;
// //     }
// //
// //     final success = await vitalInfo.save(patientID);
// //     if (success) {
// //       print("dapat");
// //     } else {
// //       print("takdapat");
// //     }
// //
// //     setState(() {
// //       _isLoading = false;
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(success ? '$title saved successfully' : 'Failed to save $title')),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<PricePoint> pricePoints = getPricePoints(_chartData, _chartDates);
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Patient Weight', style: GoogleFonts.lato()),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _attributeController,
// //               keyboardType: TextInputType.number,
// //               decoration: InputDecoration(
// //                 labelText: 'Enter ${title}',
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             _isLoading
// //                 ? CircularProgressIndicator()
// //                 : ElevatedButton(
// //               onPressed: saveInfo,
// //               child: Text('Save'),
// //             ),
// //             SizedBox(height: 20),
// //             _chartData.isNotEmpty
// //                 ? Expanded(child: LineChartWidget(pricePoints))
// //                 : Text('No data available'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:collection/collection.dart';
//
// import '../../../Controller/requestController.dart';
// import '../../../Model/vitalInfo.dart';
//
// class AddPatientInfo extends StatefulWidget {
//   final int patientID;
//   final String attribute;
//   final String title;
//
//   AddPatientInfo({
//     required this.patientID,
//     required this.attribute,
//     required this.title,
//   });
//
//   @override
//   State<AddPatientInfo> createState() => _AddPatientInfoState();
// }
//
// class _AddPatientInfoState extends State<AddPatientInfo> {
//   late int patientID;
//   late String attribute;
//   late String title;
//
//   final TextEditingController _attributeController = TextEditingController();
//   bool _isLoading = false;
//   List<double> _chartData = [];
//   List<String> _chartDates = [];
//
//   @override
//   void initState() {
//     super.initState();
//     patientID = widget.patientID;
//     attribute = widget.attribute;
//     title = widget.title;
//     loadChartData();
//   }
//
//   Future<void> loadChartData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       List<double> attributeValues = [];
//       List<String> chartDates = [];
//
//       List<VitalInfo> vitalInfos =
//       await VitalInfo.getVitalInfoSpecificAttribute(patientID, attribute);
//       if (vitalInfos.isNotEmpty) {
//         for (var vitalInfo in vitalInfos) {
//           double? value;
//
//           switch (attribute) {
//             case 'weight':
//               value = vitalInfo.weight;
//               break;
//             case 'height':
//               value = vitalInfo.height;
//               break;
//             case 'waistCircumference':
//               value = vitalInfo.waistCircumference;
//               break;
//             case 'bloodPressure':
//               value = vitalInfo.bloodPressure;
//               break;
//             case 'bloodGlucose':
//               value = vitalInfo.bloodGlucose;
//               break;
//             case 'heartRate':
//               value = vitalInfo.heartRate;
//               break;
//           }
//
//           if (value != null) {
//             attributeValues.add(value);
//             chartDates.add(vitalInfo.latestDate);
//           }
//         }
//
//         setState(() {
//           _chartData = attributeValues;
//           _chartDates = chartDates;
//         });
//       }
//     } catch (e) {
//       print('Error loading attribute data: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> saveInfo() async {
//     if (_attributeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter $title')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     double? value = double.tryParse(_attributeController.text);
//     if (value == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a valid $title')),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }
//
//     final vitalInfo = VitalInfo(
//       latestDate: DateTime.now().toIso8601String(),
//       patientID: patientID,
//     );
//
//     switch (attribute) {
//       case 'weight':
//         vitalInfo.weight = value;
//         break;
//       case 'height':
//         vitalInfo.height = value;
//         break;
//       case 'waistCircumference':
//         vitalInfo.waistCircumference = value;
//         break;
//       case 'bloodPressure':
//         vitalInfo.bloodPressure = value;
//         break;
//       case 'bloodGlucose':
//         vitalInfo.bloodGlucose = value;
//         break;
//       case 'heartRate':
//         vitalInfo.heartRate = value;
//         break;
//       default:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Invalid attribute')),
//         );
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//     }
//
//     final success = await vitalInfo.save(patientID);
//     if (success) {
//       print("dapat");
//     } else {
//       print("takdapat");
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(success ? '$title saved successfully' : 'Failed to save $title')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<PricePoint> pricePoints = getPricePoints(_chartData, _chartDates);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Patient Weight', style: GoogleFonts.lato()),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _attributeController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Enter ${title}',
//               ),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: saveInfo,
//               child: Text('Save'),
//             ),
//             SizedBox(height: 20),
//             _chartData.isNotEmpty
//                 ? Expanded(child: content(pricePoints))
//                 : Text('No data available'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget content(List<PricePoint> pricePoints) {
//     return Container(
//       child: LineChartWidget(pricePoints),
//     );
//   }
// }
//
// class PricePoint {
//   final double x;
//   final double y;
//   final String date;
//   PricePoint({required this.x, required this.y, required this.date});
// }
//
// List<PricePoint> getPricePoints(List<double> data, List<String> dates) {
//   return data
//       .mapIndexed((index, element) => PricePoint(x: index.toDouble(), y: element, date: dates[index]))
//       .toList();
// }
//
// class LineChartWidget extends StatefulWidget {
//   final List<PricePoint> points;
//
//   const LineChartWidget(this.points, {Key? key}) : super(key: key);
//
//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }
//
// class _LineChartWidgetState extends State<LineChartWidget> {
//   late List<PricePoint> points;
//
//   final List<Color> gradientColor = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a)
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     points = widget.points;
//   }
//
//   String getFormattedDate(int index) {
//     // Assuming the date is in the format "yyyy-MM-dd" and converting it to "dd/MM"
//     DateTime dateTime = DateTime.parse(points[index].date);
//     return "${dateTime.day}/${dateTime.month}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 2,
//       child: LineChart(LineChartData(
//         gridData: FlGridData(
//           show: true,
//           getDrawingHorizontalLine: (value) {
//             return FlLine(
//               color: const Color(0xff37434d),
//               strokeWidth: 1,
//             );
//           },
//           drawVerticalLine: true,
//           getDrawingVerticalLine: (value) {
//             return FlLine(
//               color: const Color(0xff37434d),
//               strokeWidth: 1,
//             );
//           },
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: const Color(0xff37434d), width: 1),
//         ),
//         lineBarsData: [
//           LineChartBarData(
//             spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
//             isCurved: true,
//             barWidth: 5,
//             belowBarData: BarAreaData(
//               show: true,
//               color: Color(0xff37434d).withOpacity(0.8),
//             ),
//             dotData: FlDotData(show: true),
//           ),
//         ],
//       )),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';

import '../../../Controller/requestController.dart';
import '../../../Model/vitalInfo.dart';

class AddPatientInfo extends StatefulWidget {
  final int patientID;
  final String attribute;
  final String title;

  AddPatientInfo({
    required this.patientID,
    required this.attribute,
    required this.title,
  });

  @override
  State<AddPatientInfo> createState() => _AddPatientInfoState();
}

class _AddPatientInfoState extends State<AddPatientInfo> {
  late int patientID;
  late String attribute;
  late String title;

  final TextEditingController _attributeController = TextEditingController();
  bool _isLoading = false;
  List<double> _chartData = [];
  List<String> _chartDates = [];

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    attribute = widget.attribute;
    title = widget.title;
    loadChartData();
  }

  Future<void> loadChartData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<double> attributeValues = [];
      List<String> chartDates = [];

      List<VitalInfo> vitalInfos =
      await VitalInfo.getVitalInfoSpecificAttribute(patientID, attribute);
      if (vitalInfos.isNotEmpty) {
        for (var vitalInfo in vitalInfos) {
          double? value;

          switch (attribute) {
            case 'weight':
              value = vitalInfo.weight;
              break;
            case 'height':
              value = vitalInfo.height;
              break;
            case 'waistCircumference':
              value = vitalInfo.waistCircumference;
              break;
            case 'bloodPressure':
              value = vitalInfo.bloodPressure;
              break;
            case 'bloodGlucose':
              value = vitalInfo.bloodGlucose;
              break;
            case 'heartRate':
              value = vitalInfo.heartRate;
              break;
          }

          if (value != null) {
            attributeValues.add(value);
            chartDates.add(vitalInfo.latestDate);
          }
        }

        setState(() {
          _chartData = attributeValues;
          _chartDates = chartDates;
        });
      }
    } catch (e) {
      print('Error loading attribute data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> saveInfo() async {
    if (_attributeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter $title')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    double? value = double.tryParse(_attributeController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid $title')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final vitalInfo = VitalInfo(
      latestDate: DateTime.now().toIso8601String(),
      patientID: patientID,
    );

    switch (attribute) {
      case 'weight':
        vitalInfo.weight = value;
        break;
      case 'height':
        vitalInfo.height = value;
        break;
      case 'waistCircumference':
        vitalInfo.waistCircumference = value;
        break;
      case 'bloodPressure':
        vitalInfo.bloodPressure = value;
        break;
      case 'bloodGlucose':
        vitalInfo.bloodGlucose = value;
        break;
      case 'heartRate':
        vitalInfo.heartRate = value;
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid attribute')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
    }

    final success = await vitalInfo.save(patientID);
    if (success) {
      loadChartData(); // Refresh chart data after saving new info
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? '$title saved successfully' : 'Failed to save $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PricePoint> pricePoints = getPricePoints(_chartData, _chartDates);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient Info', style: GoogleFonts.lato()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _attributeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter $title',
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: saveInfo,
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            _chartData.isNotEmpty
                ? Expanded(child: LineChartWidget(pricePoints))
                : Text('No data available'),
          ],
        ),
      ),
    );
  }
}

class PricePoint {
  final double x;
  final double y;
  final String date;
  PricePoint({required this.x, required this.y, required this.date});
}

List<PricePoint> getPricePoints(List<double> data, List<String> dates) {
  return data
      .mapIndexed((index, element) => PricePoint(x: index.toDouble(), y: element, date: dates[index]))
      .toList();
}

class LineChartWidget extends StatefulWidget {
  final List<PricePoint> points;

  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late List<PricePoint> points;

  final List<Color> gradientColor = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a)
  ];

  @override
  void initState() {
    super.initState();
    points = widget.points;
  }

  String getFormattedDate(int index) {
    DateTime dateTime = DateTime.parse(points[index].date);
    return "${dateTime.day}/${dateTime.month}";
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: true,
              barWidth: 5,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(colors: gradientColor),
              ),
              dotData: FlDotData(show: true),
            ),
          ],

          // getTitleData()=> FlTitlesData(
          //   leftTitles: SideTitles(showTitles: true),
          //   bottomTitles: SideTitles(
          //     showTitles: true,
          //     getTitles: (value) {
          //       return getFormattedDate(value.toInt());
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
}
