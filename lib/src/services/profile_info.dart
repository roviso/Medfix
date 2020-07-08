import 'package:cloud_firestore/cloud_firestore.dart';

class Profileinfo{
  getProfile(String patientId) async{
        return await Firestore.instance
        .collection('patients')
        .getDocuments();
  }
}
