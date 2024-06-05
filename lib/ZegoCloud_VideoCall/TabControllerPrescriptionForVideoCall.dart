import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fyp/ZegoCloud_VideoCall/PatientPastMedication.dart';
import 'package:fyp/ZegoCloud_VideoCall/doPrediction.dart';
import 'package:fyp/ZegoCloud_VideoCall/videoCall.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'ConsultationPrescriptionV2.dart';

class ButtonCallwithTabControllerPrescription extends StatefulWidget {
  final int patientID;
  final String patientName;
  final int consultationID;
  final int roleID;
  final int specialistID;

  const ButtonCallwithTabControllerPrescription({
    required this.patientName,
    required this.patientID,
    required this.consultationID,
    required this.roleID,
    required this.specialistID,
  });

  @override
  State<ButtonCallwithTabControllerPrescription> createState() => _ButtonCallwithTabControllerPrescriptionState();
}

class _ButtonCallwithTabControllerPrescriptionState extends State<ButtonCallwithTabControllerPrescription> with SingleTickerProviderStateMixin {
  late int patientID;
  late int consultationID;
  late String patientName;
  late int roleID;
  late int specialistID;

  late TabController _tabController; // Add TabController
  final PageStorageBucket bucket = PageStorageBucket();

  List<String> prescriptionSymptoms = ['']; // Store symptoms for prescription

  @override
  void initState() {
    super.initState();
    patientID = widget.patientID;
    patientName = widget.patientName;
    consultationID = widget.consultationID;
    roleID = widget.roleID;
    specialistID = widget.specialistID;
    _tabController = TabController(length: 3, vsync: this);


    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(

      length: 3,
        child:Scaffold(

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
        bottom: TabBar(
          controller: _tabController,
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
              text: 'Do Prediction',
            ),
            CustomTab(
              text: 'Vital Info History',
            ),

          ],
        ),
      ),

      body: PageStorage(
        bucket: bucket,
        child: TabBarView(
          controller: _tabController,
          children: [
            ConsultationPrescription(
              key:PageStorageKey('Medical Record'),
              patientID:patientID,
              patientName:patientName,
              consultationID: consultationID,
              specialistID: specialistID,
              roleID: roleID,
            ),
            DoPrediction(

                key:PageStorageKey('Do Prediction'),
                patientID:patientID,
                patientName:patientName,
                consultationID: consultationID,
                specialistID: specialistID,
                roleID: roleID,


            ),
            PatientPastMedication(
              key:PageStorageKey('Vital Info History'),
                patientID:patientID,
                specialistID: specialistID,
                ),


          ],
        ),
      ),

    ),
      ),
    );

  }
  //
  // void onSendCallInvitationFinished(
  //     String code, String message, List<String> errorInvitees) {
  //   if (errorInvitees.isNotEmpty) {
  //     String userIDs = "";
  //     for (int index = 0; index < errorInvitees.length; index++) {
  //       if (index >= 5) {
  //         userIDs += '... ';
  //         break;
  //       }
  //
  //       var userID = errorInvitees.elementAt(index);
  //       userIDs += userID + ' ';
  //     }
  //     if (userIDs.isNotEmpty) {
  //       userIDs = userIDs.substring(0, userIDs.length - 1);
  //     }
  //
  //     var message = 'User doesn\'t exist or is offline: $userIDs';
  //     if (code.isNotEmpty) {
  //       message += ', code: $code, message:$message';
  //     }
  //     showToast(
  //       message,
  //       position: StyledToastPosition.top,
  //       context: context,
  //     );
  //   } else if (code.isNotEmpty) {
  //     showToast(
  //       'code: $code, message:$message',
  //       position: StyledToastPosition.top,
  //       context: context,
  //     );
  //   }
  // }
  //
  // Widget sendCallButton({
  //   required String patientID,
  //   required String patientName,
  //   void Function(String code, String message, List<String>)? onCallFinished,
  // }) {
  //   return ZegoSendCallInvitationButton(
  //     isVideoCall: true,
  //     invitees: [
  //       ZegoUIKitUser(
  //         id: patientID,
  //         name: patientName,
  //       ),
  //     ],
  //     resourceID: "zego_data",
  //     iconSize: const Size(40, 40),
  //     buttonSize: const Size(50, 50),
  //     onPressed: onCallFinished,
  //   );
  // }

  @override
  void dispose() {
    // Dispose the TabController
    _tabController.dispose();
    super.dispose();
  }
}



class CustomTab extends StatefulWidget {
  final String text;

  CustomTab({required this.text});


  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  late String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = widget.text;
  }
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
