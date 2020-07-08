import 'package:flutter/material.dart';
import 'dart:async';
import 'top_layout.dart';

class PatientProfile extends StatelessWidget{
  final String patient_name;
  final String patient_email;
  final String patient_img;
  final String patient_address;

   PatientProfile({
    @required this.patient_name,
    @required this.patient_email,
    @required this.patient_img,
    @required this.patient_address,
   });

  Widget build(context){

     return new Container(

          child: Material(
            elevation: 7.0,
            borderRadius: BorderRadius.circular(7.0),
            child: Container(              
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(child: Text('My Profile', style: TextStyle(fontSize: 17.0), textAlign: TextAlign.center,)),                  
                  SizedBox(height: 10.0,),
                  Container(      
                    height: 0.5,
                    width: double.infinity,
                    color: Colors.blue,),
                  // SizedBox(height: 45.0,),
                  // Row(children: <Widget>[
                  //   Row(children: <Widget>[
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[                    
                          Center(
                            child: Container(
                              margin: new EdgeInsets.all(10.0),
                            height: 150.0,
                            width: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  patient_img),
                                  fit: BoxFit.cover

                                )
                              )
                            )),
                            Center(child: Text('Name:'+
                              patient_name,
                              style: TextStyle(fontSize: 14.0),
                            ),),
                            Center(child: Text('Email:'+
                              patient_email,
                              style: TextStyle(fontSize: 14.0),
                            ),),
                            Center(child: Text('Address:'+
                              patient_address,
                              style: TextStyle(fontSize: 14.0),
                            ),),
                          

                      ],),


                    //],)
                 // ],)

               // ],
              ),
            
            ),
         // ),
          );
        
    
  }
}





  
//   class getClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = new Path();

//     path.lineTo(0.0, size.height / 1.9);
//     path.lineTo(size.width + 125, 0.0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return true;
//   }
// }





