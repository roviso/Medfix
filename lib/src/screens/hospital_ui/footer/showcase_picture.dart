import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';

class PictureShowcase extends StatelessWidget{
  final Hospitals hospital;
 
  PictureShowcase(this.hospital);

  @override
  Widget build(context){
    var items = <Widget>[];
      for (var i = 0; i < hospital.pictures.length; i++){
        var image = new Image.network(
          hospital.pictures[i],
          width: 200.0,
          height: 200.0,
        );
        items.add(image);
      }

      var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      );
      return new GridView(
        padding: const EdgeInsets.only(top: 16.0),
        gridDelegate: delegate,
        children: items,
      );
  }

}