import 'package:meta/meta.dart';

class Appoinment{
  final String documentId;
  final String appintment_id;
  final String doctor_id;
  final String hospital_id;
  final String patient_id;
  final bool is_pending;
  final bool is_confirmed;
  final String time_of_appointment;



  Appoinment(
    this.is_pending,
    this.is_confirmed,
    this.time_of_appointment,
    {
    @required this.documentId,
    @required this.doctor_id,
    @required this.appintment_id,
    @required this.hospital_id,
    @required this.patient_id,


  });

   
}