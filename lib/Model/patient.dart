import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/requestController.dart';

class Patient{

  dynamic patientID;
  String? patientName;
  String? phone;
  String? icNumber;
  String? gender;
  DateTime? birthDate;
  String? password;
  Uint8List? patientImage;
  int? age;




  Patient({
    required this.patientID,
    required this.patientName,
    required this.phone,
    required this.icNumber,
    required this.gender,
    required this.birthDate,
    required this.password,
    this.patientImage,
    required this.age
  });


  Patient.fromJson(Map<String, dynamic> json)
      : patientName = json['patientName'] as String?,
        phone = json['phone'] as String?,
        icNumber = json['icNumber'] as String?,
        gender = json['gender'] as String?,
        birthDate = _parseDateTime(json['birthDate'] as dynamic),
        password = json['password'] as String?,
        patientImage = base64Decode(json["base64Image"] ?? '');


  static DateTime? _parseDateTime(dynamic dateTimeString) {
    if (dateTimeString == null) {
      return null;
    }

    try {
      if (dateTimeString is String) {
        return DateTime.parse(dateTimeString);
      } else {
        print("Error parsing date string: $dateTimeString");
        return null;
      }
    } catch (e) {
      print("Error parsing date string: $dateTimeString");
      print("Error details: $e");
      return null;
    }
  }

  Map<String, dynamic> toJson() =>
      {
        'patientName': patientName,
        'phone': phone,
        'icNumber': icNumber,
        'gender': gender,
        'birthDate': birthDate?.toString(), // Convert DateTime to string
        'password': password,
        'patientImage' : patientImage
      };

}