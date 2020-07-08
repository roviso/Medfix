import 'package:meta/meta.dart';

class AppoinmentPending{
  final String documentId;
  final String doctor_id;

  final String patient_id;
  final String pending_date;




  AppoinmentPending(

    {
    @required this.documentId,
    @required this.doctor_id,

    @required this.patient_id,
    @required this.pending_date,

  });

   
}