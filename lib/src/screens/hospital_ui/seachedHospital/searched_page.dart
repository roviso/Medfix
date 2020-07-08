import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:catbox/src/services/api.dart';
import 'header/hospital_detail_header.dart';
import 'hospital_detail_body.dart';
import '../footer/detail_footer.dart';
import '../../home_screen.dart';

class SearchedPage extends StatefulWidget{
  final String hospitalName;

  

  SearchedPage(this.hospitalName);

  @override
  _SearchedPageState createState() => new _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage>{
   Hospitals _hospitals;
 

  Api _api;
  //NetworkImage _profileImage;

  @override
  void initState(){
    super.initState();
    _loadFromFirebase();

  }

  _loadFromFirebase() async{
    final api = await Api.getApi();
    final List<Hospitals> hospitals = await api.getHospital(widget.hospitalName);
    setState(() {
          _api = api;
          _hospitals = hospitals[0];
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

       drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Welcome"),
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
              title: new Text("back"),
              trailing: new Icon(Icons.arrow_back),
              onTap: () =>  Navigator.of(context).pop(),
            ),
          ],
        ),
      ),

      body: new SingleChildScrollView(
       child: new Container(
         decoration: linearGradient,
         child: new Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             new HospitalDetailHeader(
               _hospitals,
               
             ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new HospitalDetailBody(_hospitals),
              ),

              new Hospitalshowcase(_hospitals), 

           ],
         )

       ),
      )
    );
    
  }
}