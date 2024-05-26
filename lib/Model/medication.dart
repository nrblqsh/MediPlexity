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
    this.consultationSymptom
  });

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
    medID: json["MedID"] ?? 0,
    consultationID: json["consultationID"] ?? 0,
    medicationID: json["medicationID"] ?? 0,
    medGeneral: json["MedGeneral"],
    medForm: json["medForm"],
    consultationDateTime: json['consultationDateTime'] != null
        ? DateTime.tryParse(json['consultationDateTime'])
        : DateTime.parse('0000-00-00'),
    consultationDateTimeFinished:
    json['consultationDateTimeFinished'] != null
        ? DateTime.tryParse(json['consultationDateTimeFinished'])
        : DateTime.parse('0000-00-00'),
    dosage: json["dosage"],
    medInstruction: json["medInstruction"],
    consultationSymptom: json["consultationSymptom"],
  );

  Map<String, dynamic> toJson() => {
    "MedID": medID,
    "consultationID": consultationID,
    "medicationID": medicationID,
    "MedGeneral": medGeneral,
    "medForm": medForm,
    'consultationDateTime': consultationDateTime.toString(),
    "dosage": dosage,
    "medInstruction": medInstruction,
    "consultationDateTimeFinished":
    consultationDateTimeFinished.toString(),
    "consultationSymptom":consultationSymptom
  };

  static Future<List<Medication>> getConsultationMedicationDuringVideoCallforSpecialist(
      int patientID) async {
    RequestController req = RequestController(
      path: "/mediplexity/getPatientMedicationDuringVideoCall.php?patientID=$patientID",
    );

    // Make a GET request
    print("Request URL: ${req.path}");

    await req.get();
    print("Response Status: ${req.status()}");
    print("Response Body: ${req.result()}");

    if (req.status() == 200 && req.result() != null) {
      dynamic resultData = req.result();

      print("Raw JSON Data: $resultData");

      try {
        if (resultData is List) {
          // Handle the case when the result is an array
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
      // Handle the case when the request failed
      print('Error loading medications: ${req.status()}');
      return [];
    }
  }
}
