import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Controller/requestController.dart';

class Medication {
  int? medID;
  int? consultationID;
  int? medicationID;
  String? medGeneral;
  String? medForm;
  DateTime? consultationDateTime;
  String? dosage;
  String? medInstruction;
  DateTime? consultationDateTimeFinished;
  String? consultationSymptom;

  Medication({
    this.medID,
    this.consultationID,
    this.medicationID,
    this.medGeneral,
    this.medForm,
    this.consultationDateTime,
    this.dosage,
    this.medInstruction,
    this.consultationDateTimeFinished,
    this.consultationSymptom,
  });

  factory Medication.fromJson(Map<String, dynamic> json) =>
      Medication(
        medID: json["MedID"] ?? 0,
        consultationID: json["consultationID"] ?? 0,
        medicationID: json["medicationID"] ?? 0,
        medGeneral: json["MedGeneral"],
        medForm: json["MedForm"],
        consultationDateTime: json['consultationDateTime'] != null
            ? DateTime.tryParse(json['consultationDateTime'])
            : DateTime.parse('0000-00-00'),
        consultationDateTimeFinished: json['consultationDateTimeFinished'] !=
            null
            ? DateTime.tryParse(json['consultationDateTimeFinished'])
            : DateTime.parse('0000-00-00'),
        dosage: json["dosage"],
        medInstruction: json["medInstruction"],
        consultationSymptom: json["consultationSymptom"],
      );

  Map<String, dynamic> toJson() =>
      {
        "MedID": medID,
        "consultationID": consultationID,
        "medicationID": medicationID,
        "MedGeneral": medGeneral,
        "medForm": medForm,
        'consultationDateTime': consultationDateTime?.toIso8601String(),
        "dosage": dosage,
        "medInstruction": medInstruction,
        "consultationDateTimeFinished": consultationDateTimeFinished
            ?.toIso8601String(),
        "consultationSymptom": consultationSymptom,
      };

  static Future<List<Medication>> loadAllMedications() async {
    RequestController req = RequestController(
      path: "/mediplexity/getMedicineforVideoConsultation.php",
    );

    print("Request URL: ${req.path}");
    await req.get();
    print("Response Status: ${req.status()}");
    print("Response Body: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();
      print("Raw JSON Data: $resultData");

      try {
        if (resultData is Map<String, dynamic> &&
            resultData.containsKey('data')) {
          var dataList = resultData['data'] as List<dynamic>;
          return dataList.map((item) => Medication.fromJson(item)).toList();
        } else {
          print('Unexpected response format. Body is not a JSON object.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      print('Error loading medications: ${req.status()}');
      return [];
    }
  }

  static Future<
      List<Medication>> getConsultationMedicationDuringVideoCallforSpecialist(
      int patientID) async {
    RequestController req = RequestController(
      path: "/mediplexity/getPatientMedicationDuringVideoCall.php?patientID=$patientID",
    );

    print("Request URL: ${req.path}");
    await req.get();
    print("Response Status: ${req.status()}");
    print("Response Body: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();
      print("Raw JSON Data: $resultData");

      try {
        if (resultData is List) {
          return resultData.map((item) => Medication.fromJson(item)).toList();
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      print('Error loading medications: ${req.status()}');
      return [];
    }
  }

  static Future<bool> insertMedication(Medication medication) async {
    RequestController req = RequestController(
      path: "/mediplexity/insertMedication.php",
    );

    // Set the body of the request
    req.setBody(medication.toJson());

    // Make the POST request
    await req.post();

    print("Response Status: ${req.status()}");
    print("Response Body: ${req.result()}");

    if (req.status() == 200) {
      dynamic resultData = req.result();
      print("Raw JSON Data: $resultData");

      try {
        if (resultData is Map<String, dynamic> &&
            resultData['success'] == true) {
          return true;
        } else {
          print('Unexpected response format or insertion failed.');
          return false;
        }
      } catch (e) {
        print('Error parsing response: $e');
        return false;
      }
    } else {
      print('Error inserting medication: ${req.status()}');
      return false;
    }
  }

  static Future<bool> checkMedicationExists(String name, String form,
      String dosage) async {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "MedGeneral": name,
      "MedForm": form,
      "dosage": dosage,
    };

    // Create a RequestController instance
    RequestController req = RequestController(
      path: "/mediplexity/insertMedicationDetails.php", // Adjust the path as per your API
    );

    // Set the request body
    req.setBody(requestBody);

    try {
      // Make the POST request
      await req.post();

      // Check the status code of the response
      if (req.status() == 200) {
        // Parse the response data
        dynamic responseData = req.result();

        // Check if medication exists based on the response
        return responseData['status'] == 'success';
      } else {
        // Handle other status codes (e.g., server errors)
        print('Failed to check medication existence. Status code: ${req
            .status()}');
        return false;
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error checking medication existence: $e');
      return false;
    }
  }

  static Future<int> getMedID(String name, String form, String dosage) async {
    Map<String, dynamic> requestBody = {
      "MedGeneral": name,
      "MedForm": form,
      "dosage": dosage,
    };

    RequestController req = RequestController(
      path: "/mediplexity/insertNewMedicationforVideoCall.php",
    );

    req.setBody(requestBody);

    try {
      await req.post();

      if (req.status() == 200) {
        dynamic responseData = req.result();

        if (responseData is Map<String, dynamic> &&
            responseData['status'] == 'success') {
          print("Received JSON String: $responseData");
          return responseData['MedID']; // Return the MedID if medication exists or was inserted successfully
        } else if (responseData is Map<String, dynamic> &&
            responseData['status'] == 'successExisting') {
          print("Received JSON String for Existing Medicine: $responseData");
          return responseData['MedID'];
        } else {
          print('Unexpected response format or medication insertion failed.');
          return -1;
        }
      } else {
        print('Failed to check or insert medication. Status code: ${req
            .status()}');
        return -1;
      }
    } catch (e) {
      print('Error checking or inserting medication: $e');
      return -1;
    }
  }

  static Future<int> getExistingMedID(String name, String form,
      String dosage) async {
    Map<String, dynamic> requestBody = {
      "MedGeneral": name,
      "MedForm": form,
      "dosage": dosage,
    };

    print(name);
    print(form);
    print(dosage);

    RequestController req = RequestController(
      path: "/mediplexity/getMedIDforMedicineVideoCall.php",
    );

    req.setBody(requestBody);

    try {
      await req.post();

      if (req.status() == 200) {
        dynamic responseData = req.result();

        print(
            "Received JSON Response: $responseData"); // Add this line to print the entire response

        if (responseData is Map<String, dynamic> &&
            responseData['status'] == 'success') {
          print("Received JSON String: $responseData");
          // Extract and return the MedID from the JSON response
          return int.parse(responseData['MedID']);
        } else {
          print('Unexpected response format or medication insertion failed.');
          return -1;
        }
      } else {
        print('Failed to check or insert medication. Status code: ${req
            .status()}');
        return -1;
      }
    } catch (e) {
      print('Error checking or inserting medication: $e');
      return -1;
    }
  }


  static Future<void> insertMedicationsVideoCall(int consultationID,
      List<int> medIDs, List<String> medInstructions) async {
    try {
      // Construct the URL
      String url = '/mediplexity/insertMedicationDetails.php'; // Your PHP script path

      // Prepare the medications data
      List<Map<String, dynamic>> medications = [];
      for (int i = 0; i < medIDs.length; i++) {
        medications.add({
          'MedID': medIDs[i],
          'MedInstruction': medInstructions[i],
        });
      }

      // Prepare the body of the request
      Map<String, dynamic> body = {
        'consultationID': consultationID,
        'medications': medications,
      };

      // Instantiate RequestController with the appropriate path
      RequestController req = RequestController(
        path: url,
      );

      // Set the body parameters
      req.setBody(body);

      // Make a POST request
      await req.post();

      // Check the response status
      print('Response Status: ${req.status()}');
      print('Response Body: ${req.result()}');

      if (req.status() == 200) {
        // Data inserted successfully
        print('Medications inserted successfully');
      } else {
        throw Exception('Failed to insert medications');
      }
    } catch (e) {
      print('Error during medications insertion: $e');
      throw Exception('Error during medications insertion: $e');
    }
  }

  Future<List<Medication>> fetchPatientMedication(int consultationID) async {
    try {
      // Instantiate RequestController with the appropriate path
      RequestController req = RequestController(
        path: '/mediplexity/getPatientMedication.php?consultationID=$consultationID',
      );

      // Make a GET request
      await req.get();

      // Check the response status
      if (req.status() == 200) {
        // Parse the response data
        dynamic resultData = req.result();

        // Check if the response data contains the 'data' field
        if (resultData is Map<String, dynamic> && resultData.containsKey('data')) {
          final nestedData = resultData['data']['data'];

          // Check if nestedData is a List
          if (nestedData is List<dynamic>) {
            // Map the JSON data to a list of Medication objects
            List<Medication> meds = nestedData
                .map((medicationData) => Medication.fromJson(medicationData as Map<String, dynamic>))
                .toList();
            print('responseData $resultData');
            print('meds $meds');
            return meds;
          } else {
            throw Exception('Unexpected format for "data" field');
          }
        } else {
          throw Exception('No "data" field in the response');
        }
      } else {
        throw Exception('Failed to fetch medications');
      }
    } catch (e) {
      print('Error fetching medications: $e');
      throw Exception('Error fetching medications');
    }
  }

}
