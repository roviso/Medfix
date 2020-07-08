import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  Future updateProfilePic(String picUrl) {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;

    FirebaseAuth.instance
      .updateProfile(userInfo)
      .then((val){
        FirebaseAuth.instance.currentUser().then((user){
          Firestore.instance.collection('/patients')
          .where('patient_id', isEqualTo: user.uid)          
          .getDocuments()
          .then((docs){
            print(docs.documents[0].documentID);
            Firestore.instance.document('/patients/${docs.documents[0].documentID}')
            .updateData({'patient_img': picUrl}).then((val){
              print('patient image upadated');     
                 
            }).catchError((e){
              print(e);
              
            });
          });
        }).catchError((e){
          print(e);
         
        });
      }).catchError((e){
      print(e);
    
    });
  }

}
