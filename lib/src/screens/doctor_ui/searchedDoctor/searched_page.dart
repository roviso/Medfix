import 'package:catbox/src/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:catbox/src/services/api.dart';
import 'header/doctor_detial_header.dart';
//import '../detail_body.dart';
//import '../footer/detail_footer.dart';

class SearchedPage extends StatefulWidget{
  final String doctorName;

  

  SearchedPage(this.doctorName);

  @override
  _SearchedPageState createState() => new _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage>{
   Doctors _doctors;
 

  Api _api;
  //NetworkImage _profileImage;

  @override
  void initState(){
    super.initState();
    _loadFromFirebase();

  }

  _loadFromFirebase() async{
    final api = await Api.getApi();
    final List<Doctors> doctors = await api.getDoctor(widget.doctorName);
    setState(() {
          _api = api;
          _doctors = doctors[0];
          //_profileImage = new NetworkImage(api.firebaseUser.photoUrl);
        });

  }




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
            //  new doctorDetailHeader(
            //    _doctors,
             //),


           ],
         )

       ),
      )
    );
    
  }
}