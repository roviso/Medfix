import 'package:catbox/src/models/doctor.dart';
import 'package:flutter/material.dart';


class doctorDetailBody extends StatelessWidget{
  final Doctors doctor;

  doctorDetailBody(this.doctor);


  _createCircleBadge(IconData iconData, Color color){
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,

        ),
        radius: 16.0,
      ),
    );
  }



  @override
  Widget build(context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var specialtyInfo = new Row(
      children: <Widget>[
        new Icon(
          Icons.work,
          color:Colors.blueGrey,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            doctor.doctor_specialty,
            style: textTheme.subhead.copyWith(color: Colors.blueGrey),
          ),
        )
      ],

    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          doctor.doctor_name,
          style: textTheme.headline.copyWith(color: Colors.blueGrey),

        ),
        new Text('    - '+
          doctor.doctor_sex,
          style: textTheme.body1.copyWith(color: Colors.blueGrey, fontSize:16.0),
        ),
        new Text('    - '+
          doctor.doctor_hospital,
          style: textTheme.body1.copyWith(color: Colors.blueGrey, fontSize:16.0),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: specialtyInfo,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: new Text(
            doctor.doctor_contactNo,
            style: textTheme.body1.copyWith(color: Colors.blueGrey, fontSize:16.0),
          ),
        ),

      ],
    );

  }



}