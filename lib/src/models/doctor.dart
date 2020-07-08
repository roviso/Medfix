import 'package:meta/meta.dart';

class Doctors{
  final String documentId;
  final String doctor_id;
  final String doctor_name;
  final String doctor_sex;
  final String doctor_contactNo;
  final String doctor_img;
  final String doctor_hospital;
  final String doctor_specialty;



  Doctors({
    @required this.documentId,
    @required this.doctor_id,
    @required this.doctor_name,
    @required this.doctor_sex,
    @required this.doctor_contactNo,
    @required this.doctor_img,
    @required this.doctor_hospital,
    @required this.doctor_specialty,
  });

  @override
  String toString(){
    return "Doctor $doctor_id is named $doctor_name";
  }
   
}