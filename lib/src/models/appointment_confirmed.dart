import 'package:meta/meta.dart';

class AppoinmentConfirmed{
  final String documentId;
  final String doctor_id;
  final String patient_id;
    final String hospital_id;
  final String time_of_appointment;



  AppoinmentConfirmed({
    @required this.documentId,
    @required this.doctor_id,
    @required this.patient_id,
    @required this.hospital_id,
    @required this.time_of_appointment,    
  });

   
}