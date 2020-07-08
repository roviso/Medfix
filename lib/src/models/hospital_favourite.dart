import 'package:meta/meta.dart';

class HospitalFavourite{
  final String documentId;
  final String hospital_id;
  final String patient_id;



  HospitalFavourite({
    @required this.documentId,
    @required this.hospital_id,
    @required this.patient_id,

  });
}