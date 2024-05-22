import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// void main() {
//   runApp(MedicalRecordScreen(patientID: 0 ));
// }

class MedicalRecordScreen extends StatefulWidget {
  final int patientID;

  MedicalRecordScreen({required this.patientID});

  @override
  _MedicalRecordScreenState createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  late int patientID=0;
  late String patientName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedID = prefs.getInt("patientID") ?? 0;
    // String storedName = prefs.getString("patientID") ?? "";

    setState(() {
      patientID = storedID;
      //patientName = widget.patientName;
      //print(patientID);
      //patientIDController.text = patientID.toString();
    });
  }

  //const MedicalRecordScreen({Key? key, required int patientID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 78,
            backgroundColor: Colors.white,
            title: Center(
              child: Image.asset(
                "asset/MYTeleClinic.png",
                width: 594,
                height: 258,
              ),
            ),
            bottom: TabBar(
              unselectedLabelColor: Colors.orangeAccent,
              labelColor: Colors.blueGrey,
              //
              indicatorColor: Colors.blueGrey,
              // Set the color for the selected label
              tabs: [
                CustomTab(
                  text: 'Medical Record',
                ),
                CustomTab(
                  text: 'Vital Info History',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [

            ],
          ),

        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  //final Icon icon;

  final String text;

  CustomTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Column(
        children: [
          const SizedBox(height: 20),
          Text(text),
        ],
      ),
    );
  }
}