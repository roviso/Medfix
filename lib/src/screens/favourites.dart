import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catbox/src/models/doctor.dart';
import 'package:catbox/src/models/doctor_favourite.dart';
import 'package:catbox/src/models/hospital_favourite.dart';
import '../utils/routes.dart';
import '../models/patient.dart';
import '../models/hospital.dart';
import 'profile.dart';
import '../services/api.dart';
import 'home_screen.dart';
import 'appointment.dart';
import 'hospital_ui/detail_page.dart';
import 'doctor_ui/doctor_page.dart';


class Favourites extends StatefulWidget{
  final Patient patient;
  

  Favourites(this.patient);


  createState(){return _FavouritesState();
  }
}


class _FavouritesState extends State<Favourites>{
  Api _api;
  List<Doctors> _doctors = [];
  List<Doctors> _favouritedoctors = [];
  List<DoctorFavourite> _favouriteList =[];
  List<String> favDocId = [];


  List<Hospitals> _hospitals = [];
  List<Hospitals> _favouritehospitals = [];
  List<HospitalFavourite> _favouritehospitalsList =[];
  List<String> favhospitalsId = [];



   int _page = 0;
   String tabNo = 'Favourite Hospitals';
   bool loading = true;

  @override
  void initState() {
    super.initState(); 

    loadDoctorFavourite().then((_){
      for (String docId in favDocId){
        for( int i = 0 ; i< _doctors.length; i++){
          if(_doctors[i].doctor_id == docId){
            _favouritedoctors.add(_doctors[i]);
          }
        }
      }
    });

    loadHospitalFavourite().then((_){
      for (String hospitalId in favhospitalsId){
        for( int i = 0 ; i< _hospitals.length; i++){
          if(_hospitals[i].externalId == hospitalId){
            _favouritehospitals.add(_hospitals[i]);
          }
        }
      }
    });
  }

  loadDoctorFavourite() async{
    final api = await Api.getApi(); 
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final List<Doctors> doctors = await api.getAllDoctors();
    List<DoctorFavourite> favouriteList = await api.getDoctorFavourite(firebaseUser.uid);
    setState(() {
      _api = api;
      _doctors = doctors;
      _favouriteList = favouriteList;
      favouriteList.forEach((element) => favDocId.add(element.doctor_id));
      loading = false;
    });
  } 

  loadHospitalFavourite() async{
    final api = await Api.getApi(); 
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final List<Hospitals> hospitals = await api.getAllHospitals();
    List<HospitalFavourite> favouritehospitalsList = await api.getHospitalFavourite(firebaseUser.uid);
    setState(() {
      _hospitals = hospitals;
      _favouritehospitalsList = favouritehospitalsList;
      favouritehospitalsList.forEach((element) => favhospitalsId.add(element.hospital_id));
      loading = false;
    });
  } 


  void _signOut() async{
    try{
      await Api.signedOut();
    } catch(e){
      print(e);
    }
  }

  Widget build(context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('MedFix'),
      ),
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
                // Navigator.of(context).push(new MaterialPageRoute(
                //   builder: (BuildContext context) =>
                //     new Profile(_patient)
                // ));
              } ,
            ),
            new ListTile(
              title: new Text("My Account"),
              trailing: new Icon(Icons.account_box),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Profile(widget.patient)
                ));
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue[200],
        items: <Widget>[
          Icon(Icons.list, size: 30),
          Icon(Icons.list, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
                if(_page == 0){
                  tabNo = 'Favourite Hospitals';
                }else if(_page == 1){
                  tabNo = 'Favourite Doctors';
                }
                });      //Handle button tap
        },
      ),  
      body: _body());
  }  

  Widget _body(){
    while(tabNo == 'Favourite Doctors'){
      return     Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
          titleBar(),         

        _getFavouriteDoctors(), 

        ]
      ));
    }
    while(tabNo == 'Favourite Hospitals'){
            return     Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
          titleBar(),         

        _getFavouriteHospitals(), 

        ]
      ));

    }

  }


  Widget titleBar(){
    return Container(
              //color: Colors.white70,
              child: Center(
            child: Text(tabNo, textScaleFactor: 1.5, style: TextStyle(
              color: Colors.white,
            shadows: <Shadow>[
              Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
              ),
                Shadow(
              offset: Offset(2.0, 2.0),
                blurRadius: 8.0,
              color: Color.fromARGB(125, 0, 0, 0),
              ),
              ],))));

  }

    Widget  description(Doctors doctor){
    return Container(
      child: Row(
        children: <Widget>[
          hospitalname(doctor),
          favIcon(doctor),
          

          
        ],
      ),
    );      
  }
    
  Widget  descriptionHospital(Hospitals hospital){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
      child:Text(hospital.location,
      overflow: TextOverflow.fade,)

      ),
      InkWell(
      child: new Icon(
        Icons.favorite,
        size: 30.0,
        color: Colors.red,
        ),
      onTap:(){
      }
    )
                 

          
        ],
      ),
    );      
  }


  hospitalname(Doctors doctor){
    return Expanded(
      child:Text(doctor.doctor_hospital,
      overflow: TextOverflow.fade,)

    );
    

  }

  favIcon(Doctors doctor){
      return InkWell(
      child: new Icon(
        Icons.favorite,
        size: 30.0,
        color: Colors.red,
        ),
      onTap:(){
      }
    );
  } 


  Widget _getFavouriteHospitals(){
        return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _favouritehospitals.length,
          itemBuilder: _buildFavouriteHospitalsItem,

        ),
      ));
  } 

  _navigateToHospitalDetails(Hospitals hospital, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder : (c) {
          return new HospitalDetailPage(hospital, avatarTag: avatarTag);          
        },
        settings: new RouteSettings(),
      )
    );
  }

  Widget _buildFavouriteHospitalsItem(context, int index){
    Hospitals hospital = _favouritehospitals[index];
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToHospitalDetails(hospital, index),
              //_navigateTodoctorDetails(doctor, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(hospital.avatarUrl),
                ),
              ),
              title: new Text(
                hospital.name,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: descriptionHospital(hospital),
 
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );
  }


  Widget _getFavouriteDoctors(){
        return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _favouritedoctors.length,
          itemBuilder: _buildFavouriteDoctorsItem,

        ),
      ));
  } 

  _navigateTodoctorDetails(Doctors doctor, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder : (c) {
          return new DoctorDetailPage(doctor, avatarTag: avatarTag);          
        },
        settings: new RouteSettings(),
      )
    );
  }

  Widget _buildFavouriteDoctorsItem(context, int index){
    Doctors doctor = _favouritedoctors[index];
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateTodoctorDetails(doctor, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(doctor.doctor_img),
                ),
              ),
              title: new Text(
                doctor.doctor_name,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: description(doctor),
 
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );
  }

  Future<Null> refresh() {
    _reloadnews();
    return new Future<Null>.value();

  }

  _reloadnews() async{
        if (_api != null){
         // final List<News> news = await _api.getAllNews();
      setState(() {

            });
          
  }
  }




}