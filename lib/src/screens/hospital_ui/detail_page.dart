import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'header/detail_header.dart';
import 'detail_body.dart';
import 'footer/detail_footer.dart';

class HospitalDetailPage extends StatefulWidget{
  final Hospitals hospital;
  final Object avatarTag;

  HospitalDetailPage(
    this.hospital, {
    @required this.avatarTag,
    }
  );

  @override
  _HospitalDetailPageState createState() => new _HospitalDetailPageState();
}

class _HospitalDetailPageState extends State<HospitalDetailPage>{
  @override
  Widget build(context){
    
    var linearGradient = new BoxDecoration(
      gradient: new LinearGradient(
        begin: FractionalOffset.centerRight,
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
             new HospitalDetailHeader(
               widget.hospital,
               avatarTag: widget.avatarTag,
             ),
             new Padding(
               padding: const EdgeInsets.all(24.0),
               child: new HospitalDetailBody(widget.hospital),
             ),

             new Hospitalshowcase(widget.hospital), 

           ],
         )

       ),
      )
    );
    
  }
}