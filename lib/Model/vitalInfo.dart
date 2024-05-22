
import '../Controller/requestController.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class VitalInfo {
  int? infoID;
  double? weight;
  double? height;
  double? waistCircumference;
  double? bloodPressure;
  double? bloodGlucose;
  double? heartRate;
  String latestDate;
  int? patientID;

  VitalInfo( {
     this.weight,
     this.height,
     this.bloodPressure,
     this.bloodGlucose,
     this.heartRate,
     this.waistCircumference,
     required this.latestDate,
     this.patientID,
     this.infoID,
  });

  factory VitalInfo.fromJson(Map<String, dynamic> json) {
    return VitalInfo(
      infoID: _parseInt(json['infoID']),
      weight: _parseDouble(json['weight']),
      height: _parseDouble(json['height']),
      bloodPressure: _parseDouble(json['bloodPressure']),
      bloodGlucose: _parseDouble(json['bloodGlucose']),
      heartRate: _parseDouble(json['heartRate']),
      waistCircumference: _parseDouble(json['waistCircumference']),
      latestDate: json['latestDate'] ?? '',
      patientID: _parseInt(json['patientID']),
    );
  }

  // toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'patientID': patientID,
    'weight': weight,
    'height': height,
    'waistCircumference': waistCircumference,
    'bloodPressure': bloodPressure,
    'bloodGlucose': bloodGlucose,
    'heartRate': heartRate,
    'latestDate': latestDate
  };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  // Future<bool> save(patientID) async {
  //   // API OPERATION
  //   RequestController req =
  //   RequestController(path: '/mediplexity/vitalInfoPatient1.php?patientID=$patientID');
  //   req.setBody(toJson());
  //   await req.post();
  //   if (req.status() == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  Future<bool> save(int patientID) async {
    RequestController req = RequestController(
        path: '/mediplexity/vitalInfoPatient1.php?patientID=$patientID');
    req.setBody(toJson());

    print('Sending request to save VitalInfo...');
    await req.post();

    print('Response status code: ${req.status()}');
    if (req.status() >= 200 || req.status() <300) {
      final responseBody = req.result(); // Use the result method to get the parsed response
      print('Response body: $responseBody');

      if (responseBody is Map<String, dynamic> && responseBody['message'] == 'Record inserted successfully') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }



  static Future<List<VitalInfo>> loadAll() async {
    List<VitalInfo> result = [];
    RequestController req = RequestController(path: "/mediplexity/vitalInfo.php");
    await req.get();
    if (req.status() == 200 && req.result() != null) {
      for (var item in req.result()) {
        result.add(VitalInfo.fromJson(item));
      }
    }
    return result;
  }


  static Future<List<VitalInfo>> loadLatestVitalInfo(int patientID) async {

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/vitalInfoPatientLatestLimit.php?patientID=${patientID}",
    );

    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          // Parse the list of specialists from the response
          List<VitalInfo> vitalInfoData = resultData
              .map((data) => VitalInfo.fromJson(data))
              .toList();
          return vitalInfoData;
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      // Handle the case when the request failed
      print('Error loading cpnsultation: ${req.status()}');
      return [];
    }
  }

  static Future<List<VitalInfo>> vitalInfoReport(int patientID) async {

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/vitalInfoReport.php?patientID=${patientID}",
    );

    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          // Parse the list of specialists from the response
          List<VitalInfo> vitalInfoData = resultData
              .map((data) => VitalInfo.fromJson(data))
              .toList();
          return vitalInfoData;
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      // Handle the case when the request failed
      print('Error loading cpnsultation: ${req.status()}');
      return [];
    }
  }
  static Future<List<VitalInfo>> getVitalInfoSpecificAttribute(int patientID, String attribute) async {
    RequestController req = RequestController(
      path: "/mediplexity/getVitalInfoSpecificAttribute.php?patientID=${patientID}&&attribute=${attribute}",
    );

    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          List<VitalInfo> vitalInfoData = resultData
              .map((data) => VitalInfo.fromJson(data as Map<String, dynamic>))
              .toList();
          return vitalInfoData;
        } else {
          print('Unexpected response format. Body is not a JSON array: $resultData');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      print('Error loading consultation: ${req.status()}, Response: ${req.result()}');
      return [];
    }
  }


}
