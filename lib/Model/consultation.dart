// consultation.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '';
import '../Controller/requestController.dart';
import '../main.dart';


//
class Consultation {
  int? consultationID; // Assuming it's nullable and auto-incremented
  int patientID;
  DateTime consultationDateTime;
  int specialistID;
  String? consultationSymptom;
  String? consultationTreatment;
  String consultationStatus;
  String? specialistName;
  String? patientName;
  String? icNum;
  String? gender;
  DateTime? birthDate;
  String? phone; // Add specialist's name field
  Uint8List? patientImage;
  String? feesConsultation;
  String? feesConsultationStatus;

  // int? medicationID;
  // int? MedID;
  // String? MedGeneral;
  // String? MedForm;

  //String? specialistTitle;
  //int pro


  Consultation({
    this.consultationID,
    required this.patientID,
     required this.consultationDateTime,
    required this.specialistID,
     required this.consultationStatus,
     this.consultationTreatment,
     this.consultationSymptom,
    this.specialistName,
    this.patientName,
    this.icNum,
    this.gender,
    this.birthDate,
    this.phone,
    this.patientImage,
    this.feesConsultation,
    this.feesConsultationStatus
    // this.medicationID,
    // this.MedID,
    // this.MedGeneral,
    // this.MedForm,

    // this.specialistTitle,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      consultationID: json['consultationID'] != null ? json['consultationID'] as int? : null,
      patientID: json['patientID'] != null ? json['patientID'] as int : 0, // Provide a default value if 'patientID' is null
      consultationDateTime: DateTime.parse(json['consultationDateTime']),
      specialistID: json['specialistID'] != null ? json['specialistID'] as int : 0, // Provide a default value if 'patientID' is null
      consultationTreatment: json['consultationTreatment'] ?? '',
      // Provide default value for non-nullable fields
      consultationStatus: json['consultationStatus'] ?? '',
      // Provide default value for non-nullable fields
      consultationSymptom: json['consultationSymptom'] ?? '',
      // Provide default value for non-nullable fields
      specialistName: json['specialistName'] ?? '',
      patientName: json['patientName'] ?? '',
      icNum: json['icNumber'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : DateTime.parse('0000-00-00'),
      phone: json['phone'] ?? '',
      patientImage: base64Decode(json["base64Image"] ?? ''),
      feesConsultation: json['feesConsultation'] ?? '',
      feesConsultationStatus: json['feesConsultationStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'consultationID': consultationID,
    'patientID': patientID,
    'consultationDateTime': consultationDateTime.toString(),
    'specialistID': specialistID,
    'consultationTreatment': consultationTreatment,
    'consultationStatus': consultationStatus,
    'consultationSymptom': consultationSymptom,
    'specialistName': specialistName,
    'patientName': patientName,
    'icNumber': icNum,
    'gender': gender,
    'birthDate': birthDate.toString(),
    'phone': phone,
    'patientImage': patientImage,
    'feesConsultationStatus': feesConsultationStatus
    // 'medicationID': medicationID,
    // 'MedID': MedID,
    // 'MedForm': MedForm,
    // 'MedGeneral': MedGeneral,

    //'specialistTitle':specialistTitle
  };



  //add save
  Future<bool> save() async {
    // API OPERATION
    RequestController req =
    RequestController(path: '/mediplexity/consultation.php');
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Consultation>> viewUpcomingAppointmentforPatientSide(int patientID) async {

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/consultation.php?patientID=${patientID}",
    );

    // Make a GET request
    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          // Parse the list of specialists from the response
          List<Consultation> consultation = resultData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultation;
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




  static Future<List<Consultation>> viewUpcomingAppointmentforSpecialistSide(int specialistID) async {

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/getUpcomingAppointment.php?specialistID=${specialistID}",
    );

    // Make a GET request
    await req.get();

    // Inside your getTodayAppointmentforSpecialist function
    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData['success'] == true) {
          List<dynamic> consultationData = resultData['data'];

          // Parse the list of consultations from the response data
          List<Consultation> consultations = consultationData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultations;
        } else {
          print('Error from server: ${resultData['error']}');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      // Handle the case when the request failed
      print('Error loading consultation: ${req.status()}');
      return [];
    }

  }


  static Future<void> cancelAppointment(int consultationID) async {
    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/cancelAppointment.php?consultationID=$consultationID",
    );

    // Make a DELETE request
    await req.delete();

    if (req.status() == 200) {
      print("Appointment canceled successfully");
    } else {
      // Handle the case when the request failed
      print('Error canceling appointment: ${req.status()}');
    }
  }

  static Future<Consultation?> generateConsultationDetails(int consultationID) async {
    try {
      // Create an instance of RequestController
      RequestController req = RequestController(
        path: '/mediplexity/selectedConsultation.php?consultationID=$consultationID',
      );

      // Perform GET request
      await req.get();

      // Check response status
      if (req.status() == 200) {
        var list = req.result();
        print('Received Data: $list');

        List<Consultation> _consults = (list as List<dynamic>)
            .map<Consultation>((json) => Consultation.fromJson(json as Map<String, dynamic>))
            .toList();

        if (_consults.isNotEmpty) {
          var consultation = _consults.first;
          print('Parsed Data: $consultation');
          return consultation;
        } else {
          return null;
        }
      } else {
        print('HTTP Error: ${req.status()}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  static Future<List<Consultation>> viewPatientsForSpecialist(int specialistID) async {
    RequestController req = RequestController(
      path: '/mediplexity/viewPatient.php?specialistID=$specialistID',
    );

    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          List<Consultation> consultations = resultData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultations;
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      print('Error loading consultations: ${req.status()}');
      return [];
    }
  }

  static Future<List<Consultation>> patientViewConsultationHistory(int patientID) async {
    try {
      // Instantiate the RequestController
      RequestController req = RequestController(
        path: '/mediplexity/patientConsultationHistory.php?patientID=$patientID',
      );

      // Make a GET request
      await req.get();

      // Check the response status
      if (req.status() == 200) {
        // Parse the response data
        dynamic resultData = req.result();

        // Check if the response data is a List<dynamic>
        if (resultData is List<dynamic>) {
          // Map the JSON data to a list of Consultation objects
          List<Consultation> consultations = resultData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultations;
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } else {
        // Handle the case when the request failed
        print('Error loading consultations: ${req.status()}');
        return [];
      }
    } catch (e) {
      print('Error fetching consultation history: $e');
      return []; // Return an empty list in case of error
    }
  }

  static Future<Consultation?> patientViewSpecificConsultationHistory(int consultationID, int patientID) async {
    try {
      // Create an instance of RequestController
      RequestController req = RequestController(
        path: '/mediplexity/specificPatientConsultationHistory.php?consultationID=$consultationID&patientID=${patientID}',
      );

      // Perform GET request
      await req.get();

      // Check response status
      if (req.status() == 200) {
        var list = req.result();
        print('Received Data: $list');

        List<Consultation> _consults = (list as List<dynamic>)
            .map<Consultation>((json) => Consultation.fromJson(json as Map<String, dynamic>))
            .toList();

        if (_consults.isNotEmpty) {
          var consultation = _consults.first;
          print('Parsed Data: $consultation');
          return consultation;
        } else {
          return null;
        }
      } else {
        print('HTTP Error: ${req.status()}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }


  static Future<List<Consultation>> viewSpecificPatient(int specialistID, int patientID) async {
    RequestController req = RequestController(
      path: '/mediplexity/viewPatient.php?specialistID=$specialistID&patientID=$patientID',
    );

    await req.get();

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData is List<dynamic>) {
          List<Consultation> consultations = resultData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultations;
        } else {
          print('Unexpected response format. Body is not a JSON array.');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      print('Error loading consultations: ${req.status()}');
      return [];
    }
  }


  static Future<List<Consultation>> getTodayAppointmentforSpecialist(int specialistID) async {

    // Instantiate RequestController
    RequestController req = RequestController(
      path: "/mediplexity/getTodayAppointment.php?specialistID=${specialistID}",
    );

    // Make a GET request
    await req.get();

    // Inside your getTodayAppointmentforSpecialist function
    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      try {
        if (resultData['success'] == true) {
          List<dynamic> consultationData = resultData['data'];

          // Parse the list of consultations from the response data
          List<Consultation> consultations = consultationData
              .map((data) => Consultation.fromJson(data))
              .toList();
          return consultations;
        } else {
          print('Error from server: ${resultData['error']}');
          return [];
        }
      } catch (e) {
        print('Error parsing response: $e');
        return [];
      }
    } else {
      // Handle the case when the request failed
      print('Error loading consultation: ${req.status()}');
      return [];
    }

  }


  static Future<bool> updateConsultationStatus(int consultationID, String newStatus) async {
    try {
      // Instantiate RequestController
      RequestController req = RequestController(
        path: '/mediplexity/updateConsultationStatus.php?consultationID=$consultationID&updateConsultationStatus=$newStatus',
        // Add server address if needed
      );

      // Add parameters to the URL


      // Make a GET request
      await req.get();

      // Check the response status
      if (req.status() == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating consultation status: $e');
      return false;
    }
  }



  static Future<void> insertConsultationInformation(int consultationID, String treatment, String feesConsultation, List<String> symptoms, String consultationStatus) async {
    try {
      // Concatenate symptoms into a single string
      String concatenatedSymptoms = symptoms.join(', ');

      print("c${consultationID}");
      print("t${treatment}");

      print("t${symptoms}");
      print("t${concatenatedSymptoms}");
      print("t${feesConsultation}");
      print("stattus ${consultationStatus}");

      // Construct the URL
      String url = '/mediplexity/insertPrescriptionDetailsVideoCall.php?consultationID=$consultationID';

      // Print the URL
      print('Request URL: $url');

      // Instantiate RequestController with the appropriate path
      RequestController req = RequestController(
        path: url,
        // Add server address if needed
      );

      // Set the body parameters
      Map<String, String> body = {
        'consultationTreatment': treatment,
        'consultationSymptom': concatenatedSymptoms,
        'feesConsultation': feesConsultation,
        'consultationStatus':consultationStatus

      };

      // Print the body parameters
      print('Request Body: $body');

      req.setBody(body);

      // Make a POST request
      await req.post();

      // Check the response status
      if (req.status() == 200) {
        // Data inserted successfully
        print('Data inserted successfully');
      } else {
        throw Exception('Failed to insert consultation data');
      }
    } catch (e) {
      throw Exception('Error during data insertion: $e');
    }
  }



}