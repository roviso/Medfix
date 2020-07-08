import 'dart:async';
import 'package:flutter/material.dart';
import 'package:catbox/src/models/hospital.dart';
import '../services/api.dart';
import '../utils/routes.dart';
import '../screens/hospital_ui/detail_page.dart';

  
class HospitalList extends StatefulWidget{

  _HospitalListState createState() => new _HospitalListState();
}

class _HospitalListState extends State<HospitalList>{
   List<Hospitals> _hospitals = [];
 

  Api _api;
  //NetworkImage _profileImage;

  @override
  void initState(){
    super.initState();
    _loadFromFirebase();

  }

  _loadFromFirebase() async{
    final api = await Api.getApi();
    final List<Hospitals> hospitals = await api.getAllHospitals();
    setState(() {
          _api = api;
          _hospitals = hospitals;
          //_profileImage = new NetworkImage(api.firebaseUser.photoUrl);
        });

  }

  _reloadHospitals() async{
    if (_api != null){
      final List<Hospitals> hospitals = await _api.getAllHospitals();
      setState(() {
              _hospitals = hospitals;
            });
    }
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

  Widget build(context){
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      body: _buildBody(),

    );
  }
    
  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _getAppTitleWidget(){
    return new Text(
      'Hospitals',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 23.0,
      ),
    );
  }

  Widget _getListViewWidget(){
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _hospitals.length,
          itemBuilder: _buildHospitalItem,

        ),
      ),
      );
  } 


  Widget _buildHospitalItem(context, int index){
    Hospitals hospital = _hospitals[index];
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToHospitalDetails(hospital, index),
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
              subtitle: new Text(
                hospital.location
              ),
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );
  }

  Future<Null> refresh() {
    _reloadHospitals();
    return new Future<Null>.value();

  }






}

