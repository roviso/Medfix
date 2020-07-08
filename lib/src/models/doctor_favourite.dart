import 'package:meta/meta.dart';

class DoctorFavourite{
  final String documentId;
  final String doctor_id;
  final String patient_id;



  DoctorFavourite({
    @required this.documentId,
    @required this.doctor_id,
    @required this.patient_id,

  });
}