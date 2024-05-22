import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/requestController.dart';
import '../main.dart';

class Patient{

  dynamic patientID;
  String? patientName;
  String? phone;
  String? icNumber;
  String? gender;
  DateTime? birthDate;
  String? password;
  Uint8List? patientImage;





  Patient({
     required this.patientID,
     this.patientName,
     this.phone,
     this.icNumber,
     this.gender,
     this.birthDate,
     this.password,
    this.patientImage,

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


  static Future<List<Patient>> loadAll(int patientID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int patientID = prefs.getInt("patientID") ?? 0;

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/getProfilePatient.php",
    );

    // Add patientID as a query parameter
    req.path = "${req.path}?patientID=$patientID";

    // Make a GET request
    print("Request URL: ${req.path}");

    await req.get();
    print("Response Status: ${req.status()}");
    print("Response Body: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      print("Raw JSON Data: $resultData");

      try {
        if (resultData is Map<String, dynamic> && resultData.containsKey('data')) {
          // Handle the case when the result is an array or a single object
          print("1");
          var dataList = resultData['data'] as List<dynamic>;
          return dataList.map((item) => Patient.fromJson(item)).toList();
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
      print('Error loading patients: ${req.status()}');
      return [];
    }
  }




  Future<bool> editPatient({
    String? patientName,
    String? icNumber,
    String? gender,
    DateTime? birthDate,

    Uint8List? patientImage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedID = prefs.getInt("patientID") ?? 0;
    print("patient id edit patient$storedID");
    // Specify the full URI including the host
    String fullUri = "http://${MyApp.ipAddress}/mediplexity/"
        "editProfilePatient.php?patientID=$storedID";

    try {
      // Create a `http.MultipartRequest` to send both text fields and the image file
      var request = http.MultipartRequest('POST', Uri.parse(fullUri));

      // Attach the text fields
      request.fields.addAll({
        'patientName': patientName ?? '',
        'icNumber': icNumber ?? '',
        'gender': gender ?? '',
        'birthDate': birthDate?.toString() ?? '',  // Convert to String using toString()

      });

      // Attach the image file (if it exists)
      if (patientImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            patientImage as List<int>,
            filename: 'image.jpg',
          ),
        );
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully updated the profile
        // Parse the JSON response if needed
        final Map<String, dynamic> responseData =
        json.decode(await response.stream.bytesToString());

        print('Profile Update Response: $responseData');

        return true;
      } else {
        // Handle the case when the request failed
        print('Failed to update profile. Status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      // Handle any exceptions that might occur during the request
      print('Error updating profile: $error');
      return false;
    }
  }

  static Future<Uint8List?> getPatientImage(int patientID) async {
    RequestController req = RequestController(
      path: "/mediplexity/getPatientImage.php",
    );

    // Add specialistID as a query parameter
    req.path = "${req.path}?patientID=$patientID";

    try {
      // Make a GET request using RequestController
      await req.get();

      if (req.status() == 200) {
        // Image data is available in the response body
        print('Image data: ${req.result()}');
        return req.result();
      } else if (req.status() == 404) {
        // Image not found
        print('Image not found for patientID: $patientID');
        return null;
      } else {
        // Handle other status codes
        print('Failed to retrieve image. Status: ${req.status()}');
        return null;
      }
    } catch (error) {
      // Handle any exceptions that might occur during the request
      print('Error retrieving image: $error');
      return null;
    }
  }



  static Future<List<Patient>> updatePassword(int patientID, String oldPassword, String newPassword) async {
    try {
      // Instantiate RequestController
      RequestController req = RequestController(
        path: "/mediplexity/changePassword1.php",
      );

      // Set the request body
      req.setBody({
        'patientID': patientID.toString(),
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      // Send the POST request
      await req.post();

      // Check the response status
      if (req.status() == 200) {
        final Map<String, dynamic> responseData = req.result();
        if (responseData['Success'] != null && responseData['Success']) {
          print('Password updated successfully');
          // After password update, load all patients and return the list
          return await loadAll(patientID);
        } else {
          print('Failed to update password: ${responseData['message']}');
          return [];
        }
      } else {
        print('HTTP Error: ${req.status()}');
        return [];
      }
    } catch (error) {
      print('Error updating password: $error');
      return [];
    }
  }
}

