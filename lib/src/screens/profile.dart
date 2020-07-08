import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import '../services/usermanagement.dart';
import 'package:meta/meta.dart';
import '..//services/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/patient_profile.dart';
import '../models/patient.dart';
import 'appointment.dart';
import 'favourites.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../screens/home_screen.dart';
import '../widgets/color_loader.dart';

class Profile extends StatefulWidget{

  final Patient patient;
  

  Profile(this.patient);


  createState(){
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile>{
  File newProfilePic;
  UserManagement userManagement = new UserManagement();
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.blue
    ];
  
  bool uploading = false;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      newProfilePic = tempImage;
      uploadImage();
    });
  }

  uploadImage() async{
    setState(() {
          uploading = true;
        });
    var randomno = Random(25);
    final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(
      'profilepics/${randomno.nextInt(5000).toString()}.jpg');
    final StorageUploadTask task =
      firebaseStorageRef.putFile(newProfilePic);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print(downloadUrl);
    // userManagement.updateProfilePic(downloadUrl).whenComplete((){
    //   print('upload complete');
    //   Navigator.of(context).push(new MaterialPageRoute(
    //   builder: (BuildContext context) => new HomeScreen()
    // ));

    // }
      
    // );

    await userManagement.updateProfilePic(downloadUrl).then((val) {
      print(val);
      // Navigator.of(context).pop();
      // Navigator.of(context).push(new MaterialPageRoute(
      // builder: (BuildContext context) => new HomeScreen()
      //       ));


    });

            Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new HomeScreen()
            ));
                      setState(() {
          uploading = false;
        });

  



    }
  // Widget build(context){
  // return StreamBuilder<QuerySnapshot>(
  //   stream: Firestore.instance.collection('patients')
  //           .where('patient_email', isEqualTo: widget.userEmail)
  //           .snapshots(),
  //   builder: (BuildContext context, 
  //             AsyncSnapshot<QuerySnapshot> snapshot) {
  //             if (snapshot.hasError)
  //               return new Text('Error: ${snapshot.error}');
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.waiting:
  //                   return Center(child: CircularProgressIndicator());
  //                 default:
  //                   return new ListView(
  //                     children: snapshot.data.documents
  //                       .map((DocumentSnapshot document) {
  //                         return new PatientProfile(
  //                           patient_name: document['patient_name'],
  //                           patient_email: document['patient_email'],
  //                           patient_img : document['patient_img'],
  //                           patient_address : document['patient_address'],
  //                         );
  //                     }).toList(),
  //                   );
  //               }
  //             }
  
  // );    
        
  // }



 @override
  Widget build(BuildContext context) {
     while(uploading != false){
      return new Scaffold(
        body: Container(
          child: ColorLoader(colors: colors, duration: Duration(milliseconds: 1200)),
         ));

    }
    while(uploading == false){

    return new Scaffold(

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Welcome"),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white70,
                  backgroundImage: NetworkImage(widget.patient.patient_img),                
                  
                ),
                accountEmail: Text(widget.patient.patient_name)
            ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
              onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new HomeScreen()));
              } ,
            ),
            new ListTile(
              title: new Text("Appointments"),
              trailing: new Icon(Icons.event_available),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Appointment(widget.patient)
                ));
              } ,
            ),

            new ListTile(
              title: new Text("Favourites"),
              trailing: new Icon(Icons.favorite),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Favourites(widget.patient)
                ));
              } ,
            ),
            new ListTile(
              title: new Text("My Account"),
              trailing: new Icon(Icons.account_box),
              onTap: (){
                Navigator.of(context).pop();
              } ,
            ),
            new ListTile(
              title: new Text("SignOut"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: _signOut,
            ),
            new ListTile(
              title: new Text("back"),
              trailing: new Icon(Icons.arrow_back),
              onTap: () =>  Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 7,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(widget.patient.patient_img
                                ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                      // SizedBox(height: 90.0),
                    SizedBox(height: 10),
                  Container(
                    height: 50.0,
                    width: 150.0,
                    child:  new Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.redAccent,
                      color: Colors.red,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: getImage,
                        // if (newProfilePic != null){ 
                        //         uploadImage();}getImage,
                        child: Center(
                          child:Text(
                            'Change Profile pic',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 25.0),
                Text(
                  widget.patient.patient_name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.patient.patient_sex,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Text('Address: '+
                  widget.patient.patient_address,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Text('Email: '+
                  widget.patient.patient_email,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Text('Contact No: '+
                  widget.patient.patient_contactNo.toString(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10.0),
                Text('Date of Birth: '+
                  widget.patient.patient_dob,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),

                SizedBox(height: 10.0),
                Container(
                    height: 50.0,
                    width: 75.0,
                    child: 
                    Container(
                    height: 50.0,
                    width: 100.0,
                    child: new Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.redAccent,
                      color: Colors.red,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap:(){ Navigator.of(context).pop();},
                        child: Center(
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ))
                    )

                    ],


              
            ))
      ],
    ));
  }
  }

}
  void _signOut() async{
    try{
      await Api.signedOut();

    } catch(e){
      print(e);
    }
  }

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.3);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}