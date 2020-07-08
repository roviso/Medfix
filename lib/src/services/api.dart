import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient.dart';
import '../models/news.dart';
import 'package:catbox/src/models/hospital.dart';
import 'package:catbox/src/models/doctor_favourite.dart';
import 'package:catbox/src/models/hospital_favourite.dart';
import '../models/doctor.dart';
import '../models/appointment_pending.dart';
import '../models/appointment_confirmed.dart';

class Api {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Api(FirebaseUser user) {
    this.firebaseUser = user;
  }


  static Future<Api> signInWithEmail({@required String email,   @required String password,}) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password, );
    assert(user.email != null);
    //assert(user.displayName != null);

    //assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print('${currentUser.uid}');
    print('${currentUser.email}');


    return Api(user);
  }

  static Future<Api> registerInWithEmail({@required String email,   @required String password,String patient_name,String patient_address,
    int patient_contactNo, String patient_dob, String patient_sex, String img}) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password ).then((user){
      _auth.currentUser().then((user){
        addUser(user.uid,patient_name,email,patient_address,patient_contactNo,patient_dob,patient_sex,img);
      }).catchError((e){
        print(e);
      });
    });
    assert(user.email != null);
    //assert(user.displayName != null);
    //assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return Api(user);
  }

  static Future<String> currentUser() async{
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  

  static Future<void> signedOut() async{
    await _auth.signOut();
  }

  Future<List<Patient>> getPatient(String useremail) async {
    return (await Firestore.instance.collection('patients')
    .where('patient_email', isEqualTo: useremail)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotOfPatient(snapshot))
        .toList();
  }

  Future<List<Doctors>> getDoctor(String doctorName) async {
    return (await Firestore.instance.collection('doctors')
        .where('doctor_name', isEqualTo: doctorName)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofDoctors(snapshot))
        .toList();
  }

  Future<List<DoctorFavourite>> getDoctorFavourite(String patientId) async {
    return (await Firestore.instance.collection('doctor_favourite')
        .where('patient_id', isEqualTo: patientId)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofDoctorFavourite(snapshot))
        .toList();
  }

  Future<List<Hospitals>> getHospital(String hospitalName) async {
    return (await Firestore.instance.collection('hospitals')
        .where('name', isEqualTo: hospitalName)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }


  Future<List<Hospitals>> getHospitalFromDoc(String hospitalid) async {
    return (await Firestore.instance.collection('hospitals')
        .where('id', isEqualTo: hospitalid)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }


  Future<List<Hospitals>> getAllHospitals() async {
    return (await Firestore.instance.collection('hospitals')
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  Future<List<HospitalFavourite>> getHospitalFavourite(String patientId) async {
    return (await Firestore.instance.collection('hospital_favourite')
        .where('patient_id', isEqualTo: patientId)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofHospitalFavourite(snapshot))
        .toList();
  }

  StreamSubscription watch(Hospitals hospital, void onChange(Hospitals hospital)) {
    return Firestore.instance
        .collection('hospitals')
        .document(hospital.documentId)
        .snapshots()
        .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  }

  Future<List<AppoinmentConfirmed>> getConfirmedAppointments(String patient_id, String doctor_id) async {
    return (await Firestore.instance.collection('appointment_confirmed')
        .where('patient_id', isEqualTo: patient_id )
        .where('doctor_id', isEqualTo: doctor_id)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofAppointmentConfirmed(snapshot))
        .toList();
  }

  Future<List<AppoinmentPending>> getPendingAppointments(String patient_id, String doctor_id) async {
    return (await Firestore.instance.collection('appointment_pending')
        .where('patient_id', isEqualTo: patient_id )
        .where('doctor_id', isEqualTo: doctor_id)
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofAppointmentPending(snapshot))
        .toList();
  }

  Future<List<Doctors>> getAllDoctors() async {
    return (await Firestore.instance.collection('doctors')
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofDoctors(snapshot))
        .toList();
  }
  
  Future<List<Doctors>> getSpecificDoctors(String specialty) async {
    return (await Firestore.instance.collection('doctors')
        .where('doctor_specialty', isEqualTo: specialty )
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofDoctors(snapshot))
        .toList();
  }

  Future<List<AppoinmentConfirmed>> getAppointmentConfirmed(String patientId) async {
    return (await Firestore.instance.collection('appointment_confirmed')
        .where('patient_id', isEqualTo: patientId )
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofAppointmentConfirmed(snapshot))
        .toList();
  }

  Future<List<AppoinmentPending>> getAppointmentPending(String patientId) async {
    return (await Firestore.instance.collection('appointment_pending')
        .where('patient_id', isEqualTo: patientId )
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofAppointmentPending(snapshot))
        .toList();
  }


  

  Future<List<News>> getAllNews() async {
    return (await Firestore.instance.collection('news')
        .getDocuments())
        .documents
        .map((snapshot) => _fromDocumentSnapshotofNews(snapshot))
        .toList();
  }





  Future likeHospital(Hospitals hospital) async{
    await Firestore.instance
          .collection('likes')
          .document('${hospital.documentId}:${this.firebaseUser.uid}')
          .setData({});
  }

  Future unlikeHospital(Hospitals hospital) async{
    await Firestore.instance
          .collection('likes')
          .document('${hospital.documentId}:${this.firebaseUser.uid}')
          .delete();
  }

  Future<bool> hasLikedHospital(Hospitals hospital) async{
    final like = await Firestore.instance
          .collection('likes')
          .document('${hospital.documentId}:${this.firebaseUser.uid}')
          .get();
    return like.exists;
  } 

  Hospitals _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new Hospitals(
      documentId: snapshot.documentID,
      externalId: data['id'],
      name: data['name'],
      description: data['description'],
      avatarUrl: data['img_url'],
      location: data['location'],
      likeCounter: data['like_counter'],
      pictures: new List<String>.from(data['pictures']),
      services: new List<String>.from(data['services']),
      doctors: new List<String>.from(data['doctors']),
      contactNo: data['contactNo'],
      website_url: data['website_url']
    );  
  }

  Patient _fromDocumentSnapshotOfPatient(DocumentSnapshot snapshot) {
    final data = snapshot.data; 


    return new Patient(
      document_id: snapshot.documentID,
      patient_name: data['patient_name'],
      patient_id: data['patient_id'],
      patient_email: data['patient_email'],
      patient_address: data['patient_address'],
      patient_img: data['patient_img'],
      patient_dob: data['patient_dob'],
      patient_sex: data['patient_sex'],
      patient_contactNo: data['patient_contactNo'],
    );    
  }

  Doctors _fromDocumentSnapshotofDoctors(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new Doctors(
      documentId: snapshot.documentID,
      doctor_id: snapshot.documentID,
      doctor_name: data['doctor_name'],
      doctor_sex: data['doctor_sex'],
      doctor_contactNo: data['doctor_contactNo'],
      doctor_img: data['doctor_img'],
      doctor_specialty: data['doctor_specialty'],
      doctor_hospital: data['doctor_hospital'],
    );  
  }

  HospitalFavourite _fromDocumentSnapshotofHospitalFavourite(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new HospitalFavourite(
      documentId: snapshot.documentID,
      hospital_id: data['hospital_id'],
      patient_id: data['patient_id'],
    );  
  }

  DoctorFavourite _fromDocumentSnapshotofDoctorFavourite(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new DoctorFavourite(
      documentId: snapshot.documentID,
      doctor_id: data['doctor_id'],
      patient_id: data['patient_id'],
    );  
  }

  News _fromDocumentSnapshotofNews(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new News(
      documentId: snapshot.documentID,
      news_id: data['news_id'],
      news_heading: data['news_heading'],
      news_subheading: data['news_subheading'],
      news_img: data['news_img'],
      news_body: data['news_body'],
      news_author: data['news_author'],
      news_date: data['news_date'],

    );  
  }


  AppoinmentPending _fromDocumentSnapshotofAppointmentPending(DocumentSnapshot snapshot) {
    final data = snapshot.data; 
    return new AppoinmentPending(
      documentId: snapshot.documentID,
      doctor_id: data['doctor_id'],
      patient_id: data['patient_id'],
      pending_date: data['pending_date'],

    );  
  }

  AppoinmentConfirmed _fromDocumentSnapshotofAppointmentConfirmed(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new AppoinmentConfirmed(
      documentId: snapshot.documentID,

      doctor_id: data['doctor_id'],

      patient_id: data['patient_id'],
      hospital_id: data['hospital_id'],


      time_of_appointment: data['time_of_appointment']

    );  
  }


  getProfile(String useremail){ 
    return Firestore.instance
        .collection('patients')
        .where('patient_email', isEqualTo: useremail)
        .getDocuments();       
    
  }

  static Future<FirebaseUser> getUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static Future<Api> getApi() async{
    FirebaseUser user = await _auth.currentUser();
    return Api(user);
  }


  static addUser(String patient_id,String patient_name,String patient_email,String patient_address,
    int patient_contactNo, String patient_dob, String patient_sex,String img  ) async{
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = 
        Firestore.instance.collection('patients');

      await reference.add({ 
        "patient_id" : patient_id,
        "patient_name" : patient_name,
        "patient_email" : patient_email,
        "patient_address" : patient_address,
        "patient_contactNo" : patient_contactNo,
        "patient_dob" : patient_dob,
        "patient_sex" : patient_sex,
        "patient_img" : img,
      });
    });
  }

   Future<List<Hospitals>> searchHospitals(String searchField) async {
    return (await Firestore.instance.collection('hospitals')        
        .where('searchKey',
          isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments())
        .documents        
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

}

// class Profileinfo{
//   getProfile(String userId){
//         return Firestore.instance
//         .collection('patients')
//         .where('patient_id', isEqualTo: userId)
//         .getDocuments();

//   }
// }
