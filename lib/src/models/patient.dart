import 'package:meta/meta.dart';

class Patient{
  final String document_id;
  final String patient_id;
  final String patient_name;
  final String patient_email;
  final String patient_img;
  final String patient_address;
  final String patient_sex;
  final String patient_dob;
  final int patient_contactNo;



  Patient({
    @required this.document_id,
    @required this.patient_id,
    @required this.patient_name,
    @required this.patient_email,
    @required this.patient_img,
    @required this.patient_address,
    @required this.patient_sex,
    @required this.patient_dob,
    @required this.patient_contactNo,
  });

  @override
  String toString(){
    return "cat $patient_id is named $patient_name";
  }
   
}