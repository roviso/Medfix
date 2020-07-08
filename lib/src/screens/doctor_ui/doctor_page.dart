import 'package:catbox/src/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'detail_header.dart';
import 'detail_body.dart';
//import 'footer/detail_footer.dart';

class DoctorDetailPage extends StatefulWidget{
  final Doctors doctor;
  final Object avatarTag;

  DoctorDetailPage(
    this.doctor, {
    @required this.avatarTag,
    }
  );

  @override
  _DoctorDetailPageState createState() => new _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage>{
  @override
  Widget build(context){
    
    var linearGradient = new BoxDecoration(
      gradient: new LinearGradient(
        begin: FractionalOffset.bottomRight,
        end: FractionalOffset.centerLeft,
        colors: [
          Colors.lightBlue[100],
          Colors.lightBlue[50],
        ]
      )
    );


    return new Scaffold(

      body: new SingleChildScrollView(
       child: new Container(
         decoration: linearGradient,
         child: new Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
              new DoctorDetailHeader(
                widget.doctor,
                avatarTag: widget.avatarTag,
              ),
             new Padding(
               padding: const EdgeInsets.all(24.0),
               child: new doctorDetailBody(widget.doctor),
             ),
           ],
         )

       ),
      )
    );
    
  }
}