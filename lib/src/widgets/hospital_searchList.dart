import 'dart:async';
import 'package:flutter/material.dart';
import 'package:catbox/src/models/hospital.dart';
import '../services/api.dart';
import '../utils/routes.dart';
import '../screens/hospital_ui/detail_page.dart';

  
class HospitaSearchlList extends StatelessWidget{
    final List<Hospitals> hospital;

  HospitaSearchlList(this.hospital);

  

  _navigateToHospitalDetails(BuildContext context,Hospitals hospital, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder : (c) {
          return new HospitalDetailPage(hospital, avatarTag: avatarTag);          
        },
        settings: new RouteSettings(),
      )
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

  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[

          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _buildHospitalItem(context, int index){
    Hospitals _hospital = hospital[index];


    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToHospitalDetails(context,_hospital, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(_hospital.avatarUrl),
                ),
              ),
              title: new Text(
                _hospital.name,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(
                _hospital.location
              ),
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );
  }


  Widget _getListViewWidget(){
    return new Flexible(      
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: hospital.length,
          itemBuilder: _buildHospitalItem,
        ),
      );

  } 

  Widget build(context){
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      body: _buildBody(),

    );
  }


}

