import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Controller/requestController.dart';
import '../../../Model/vitalInfo.dart';
import '../../../main.dart';
import '../../../newtestheartrate.dart';
import 'addVitalInfo.dart';

import 'package:flutter/rendering.dart';



class AddVitalInfoScreen extends StatefulWidget {
  final int patientID;

  AddVitalInfoScreen({required this.patientID});

  @override
  _AddVitalInfoScreenState createState() => _AddVitalInfoScreenState();
}


class _AddVitalInfoScreenState extends State<AddVitalInfoScreen> {
  VitalInfo? vitalInfo;

  List<VitalInfo> _vitalInfos = [];
  late List<GridColumn> _columns;

  late VitalInfoDataSource vitalInfoDataSource;
  late Future<List<VitalInfo>> _vitalInfoReportFuture ;

  int patientID = 0 ;

  double? weight;
  double? height;
  double? waistCircumference;
  double? bloodGlucose;
  double? bloodPressure;
  double? heartRate;
  String? lastVitalInfoDate;
  String? title;
  String? attribute;

  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _loadData(); // Call _loadData method to retrieve patientID
      print("test $patientID");
      vitalInfoDataSource = VitalInfoDataSource(_vitalInfos);
     await  _loadLatestVitalInfo();
      _vitalInfoReportFuture = _loadVitalInfoReport();


    });


  }


  _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Format the picked date to display only the date part
        dateController.text =
        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }


  Future<void> _initializeColumns() async {
    _columns = generateColumns(columnDefinitions);
  }


  List<GridColumn> generateColumns(List<Map<String, dynamic>> columns) {
    return columns.map((column) {
      return GridColumn(
        columnName: column['name'],
        width: column['width'],
        label: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            column['label'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }


  List<Map<String, dynamic>> columnDefinitions = [
    {
      'name': 'latestDate',
      'width': 150.00,
      'label': 'Latest Date',
    },
    {
      'name': 'weight',
      'width': 100.00,
      'label': 'Weight',
    },
    {
      'name': 'height',
      'width': 100.00,
      'label': 'Height',
    },
    {
      'name': 'waistCircumference',
      'width': 150.00,
      'label': 'Waist Circumference',
    },
    {
      'name': 'bloodPressure',
      'width': 150.00,
      'label': 'Blood Pressure',
    },
    {
      'name': 'bloodGlucose',
      'width': 150.0,
      'label': 'Blood Glucose',
    },
    {
      'name': 'heartRate',
      'width': 100.00,
      'label': 'Heart Rate',
    },

  ];

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    patientID = prefs.getInt("patientID") ?? 0;
  }


  Future<List<VitalInfo>> _loadVitalInfoReport() async {
    try {
      List<VitalInfo> vitalInfos = await VitalInfo.vitalInfoReport(patientID);
      if (mounted) {
        setState(() {
          _vitalInfos = vitalInfos;
        });
      }
      return vitalInfos;
    } catch (error) {
      print('$error');
      return []; // Return an empty list in case of an error
    }
  }





  Future<void> _loadLatestVitalInfo() async {
    try {
      List<VitalInfo> vitalInfos = await VitalInfo.loadLatestVitalInfo(
          patientID);
      setState(() {
        _vitalInfos = vitalInfos;
      });
      for (var vitalInfo in vitalInfos) {
        print('Latest Vital Info: ${vitalInfo.toJson()}');
        setState(() {
          weight = vitalInfo.weight;
          height = vitalInfo.height;
          waistCircumference = vitalInfo.waistCircumference;

          bloodGlucose = vitalInfo.bloodGlucose;
          bloodPressure = vitalInfo.bloodPressure;
          heartRate = vitalInfo.heartRate;
          lastVitalInfoDate = vitalInfo.latestDate;
        });
        print("blood${bloodGlucose}");
      }
    } catch (e) {
      print('Error loading vital info: $e');
    }
  }

  void _showMessage(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }


  Widget attributeVitalInfo(String title, String attribute,
      double? attributeValue) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 240.0),
            child: Text(
              '$title',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                textStyle: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Column(
            children: [
              SizedBox(
                width: 700,
                height: 70,
                child: Container(
                  padding: EdgeInsets.only(left: 12, right: 12,),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(

                    onPressed: attributeValue != null ? () {
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) =>
                              AddPatientInfo(patientID: patientID,
                                title: title, attribute: attribute,)));
                    } : null, // Disable button if attributeValue is null
                    child: Text("${attributeValue ?? 'N/A'}"),

                  ),),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Colors.white,
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
              padding: const EdgeInsets.only(top: 25, right: 154),
              child: Text(
                "Update Vital Info ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  textStyle: const TextStyle(fontSize: 28, color: Colors.black),
                ),
              ),
            ),


            attributeVitalInfo(
                "Weight", "weight", weight != null ? double.parse(weight.toString()) : null),
            attributeVitalInfo(
                "Height", "height", height != null ? double.parse(height.toString()) : null),
            attributeVitalInfo("Waist Circumference", "waistCircumference",
                waistCircumference != null ? double.parse(waistCircumference.toString()) : null),
            attributeVitalInfo("Blood Glucose (mg/dL)", "bloodGlucose",
                bloodGlucose != null ? double.parse(bloodGlucose.toString()) : null),
            attributeVitalInfo("Blood Pressure (mmHg)", "bloodPressure",
                bloodPressure != null ? double.parse(bloodPressure.toString()) : null),



            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 180.0),
                child: Text(
                  'Heart Rate (bpm) ',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    textStyle: const TextStyle(
                        fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Column(
                children: [
                  SizedBox(
                    width: 700,
                    height: 70,
                    child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12,),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) =>
                                      HomePagehear(patientID: patientID)));
                            },
                            child: Text("${heartRate}")
                        )
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(
                  left: 70, top: 25, right: 100, bottom: 10),
              child: Text(
                "Vital Info Report ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
            ),


            // FutureBuilder<List<VitalInfo>>(
            //   future: _vitalInfoReportFuture,
            //   builder: (context, snapshot) {
            //     if (_columns == null) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           strokeWidth: 2,
            //           value: 0.8,
            //         ),
            //       );
            //     } else if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(
            //           strokeWidth: 2,
            //           value: 0.8,
            //         ),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Error: ${snapshot.error}'),
            //       );
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return Center(
            //         child: Text('No data available'),
            //       );
            //     } else {
            //       vitalInfoDataSource.updateDataGrid(snapshot.data!);
            //       return SingleChildScrollView(
            //         scrollDirection: Axis.horizontal,
            //         child: Container(
            //           width: 1000,
            //           child: SfDataGrid(
            //             source: vitalInfoDataSource,
            //             columns: _columns!,
            //             columnWidthMode: ColumnWidthMode.fill,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),d

            // Uncomment the FutureBuilder widget
            // Inside the build method
            FutureBuilder<void>(
              future: _initializeColumns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return FutureBuilder<List<VitalInfo>>(
                    future: _vitalInfoReportFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No data available'),
                        );
                      } else {
                        vitalInfoDataSource.updateDataGrid(snapshot.data!);
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: 1000,
                            child: SfDataGrid(
                              source: vitalInfoDataSource,
                              columns: _columns!,
                              columnWidthMode: ColumnWidthMode.fill,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),




          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVitalInfoScreen(patientID: patientID),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class VitalInfoDataSource extends DataGridSource {
  VitalInfoDataSource(this.vitalInfos) {
    buildDataGridRow();
  }

  List<VitalInfo> vitalInfos = [];

  @override
  List<DataGridRow> get rows => _vitalInfoDataGridRows;

  List<DataGridRow> _vitalInfoDataGridRows = [];

  void buildDataGridRow() {
    _vitalInfoDataGridRows = vitalInfos.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<double>(columnName: 'weight', value: e.weight),
      DataGridCell<double>(columnName: 'height', value: e.height),
      DataGridCell<double>(columnName: 'waistCircumference', value: e.waistCircumference),
      DataGridCell<double>(columnName: 'bloodPressure', value: e.bloodPressure),
      DataGridCell<double>(columnName: 'bloodGlucose', value: e.bloodGlucose),
      DataGridCell<double>(columnName: 'heartRate', value: e.heartRate),
      DataGridCell<String>(columnName: 'latestDate', value: e.latestDate),
    ])).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            e.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  void updateDataGrid(List<VitalInfo> vitalInfos) {
    this.vitalInfos = vitalInfos;
    buildDataGridRow();
    notifyListeners();
  }
}