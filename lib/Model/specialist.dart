
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/requestController.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';



List<Specialist> specialistFromJson(String str) => List<Specialist>.from(json.decode(str).map((x) => Specialist.fromJson(x)));

String specialistToJson(List<Specialist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Specialist {
  dynamic specialistID;
  dynamic clinicID;
  String specialistName;
  String specialistTitle;
  String phone;
  String password;
  String logStatus;
  String clinicName;
  Uint8List? specialistImagePath;


  Specialist({
    required this.specialistID,
    required this.clinicID,
    required this.specialistName,
    required this.specialistTitle,
    required this.phone,
    required this.password,
    required this.logStatus,
    required this.clinicName,
    this.specialistImagePath


  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      specialistID: json["specialistID"],
      clinicID: json["clinicID"],
      specialistName: json["specialistName"] ?? '',
      specialistTitle: json["specialistTitle"] ?? '',
      phone: json["phone"] ?? '',
      password: json["password"] ?? '',
      logStatus: json["logStatus"] ?? '',
      clinicName: json["clinicName"] ?? '',
      specialistImagePath: base64Decode(json["base64Image"] ?? ''),


    );
  }


  Map<String, dynamic> toJson() =>
      {
        "specialistID": specialistID,
        "clinicID": clinicID,
        "specialistName": specialistName,
        "specialistTitle": specialistTitle,
        "phone": phone,
        "password": password,
        "logStatus": logStatus,
        "clinicName": clinicName,
        "specialistImagePath": specialistImagePath
      };

  static Future<List<Specialist>> loadAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int specialistID = prefs.getInt("specialistID") ?? 0;

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/getProfileSpecialist.php",
    );

    // Add specialistID as a query parameter
    req.path = "${req.path}?specialistID=$specialistID";

    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is Map<String, dynamic> &&
            resultData.containsKey('data')) {
          // The data field contains a single Specialist object
          Specialist specialist = Specialist.fromJson(resultData['data']);
          return [specialist];
        } else {
          print('Unexpected response format. Body is not a JSON object.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      // Handle the case when the request failed
      print('Error loading specialists: ${req.status()}');
      return [];
    }
  }

  static Future<List<Specialist>> viewSpecialistforPatientSide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/viewSpecialist.php",
    );

    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          // Parse the list of specialists from the response
          List<Specialist> specialists = resultData
              .map((data) => Specialist.fromJson(data))
              .toList();
          return specialists;
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
      print('Error loading specialists: ${req.status()}');
      return [];
    }
  }

  static Future<List<Specialist>> viewClinicSpecialistforPatientSide(int clinicID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/viewClinicSpecialist.php?clinicID=$clinicID ",
    );



    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          // Parse the list of specialists from the response
          List<Specialist> specialists = resultData
              .map((data) => Specialist.fromJson(data))
              .toList();
          return specialists;
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
      print('Error loading specialists: ${req.status()}');
      return [];
    }
  }



}


