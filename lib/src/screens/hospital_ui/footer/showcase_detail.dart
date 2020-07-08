import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';

class DetailShowcase extends StatelessWidget{
  final Hospitals hospital;

  DetailShowcase(this.hospital);

  @override
  Widget build(context){
    var textTheme = Theme.of(context).textTheme;


    return new Center(
      child: new Text(
        hospital.description,
        textAlign: TextAlign.justify,
        style: textTheme.subhead.copyWith(color: Colors.black87),
      ),
    );
  }

}