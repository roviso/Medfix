import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';

class DoctorShowcase extends StatelessWidget{
  final Hospitals hospital;

  DoctorShowcase(this.hospital);


  @override
  Widget build(context){
    var textTheme = Theme.of(context).textTheme;
    


    return new Center(
      child: ListView.builder(
        itemCount: hospital.doctors.length,
        itemBuilder: _buildDocList,
      
      ),
    );




  }
  Widget _buildDocList(context, int index){
    String doctorName = hospital.doctors[index];
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              title: new Text(
                doctorName,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            )
          ],

        )
      )
    );
  }

}