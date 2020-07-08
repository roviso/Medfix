import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../services/api.dart';
import '../services/searchservice.dart';
import 'package:catbox/src/models/hospital.dart';
import '../widgets/hospital_searchList.dart';
import '../screens/hospital_ui/detail_page.dart';
import '../utils/routes.dart';
import '../widgets/dot_loader.dart';
import '../widgets/dot_type.dart';

import 'hospital_ui/seachedHospital/searched_page.dart';

class SearchHospital extends StatefulWidget{
  
  

  createState(){
    return _SearchHospitaltState();
  }
}


class _SearchHospitaltState extends State<SearchHospital>{
 List<Hospitals> _hospitals = [];
 List<String> allhospitalsName = [];
 bool loading = true;
 

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
        _hospitals.forEach((element) =>
        allhospitalsName.add(element.name));
        loading = false;
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
  while(loading != false){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          title('All Hospitals'),
          SizedBox(height: 200.0,),
         // _getAppTitleWidget(),
         Center(
           child:                      ColorLoader5(
               dotOneColor: Colors.redAccent,
               dotTwoColor: Colors.blueAccent,
               dotThreeColor: Colors.green,
               dotType: DotType.circle,
               dotIcon: Icon(Icons.adjust),
               duration: Duration(seconds: 1),
             ),
         )

        ],
      ),
    );
 

    }
    while(loading == false){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          title('All Hospitals'),
          _getListViewWidget(),
        ],
      ),
    );
  }
  }

    Widget title(String title){
        return Container(
              //color: Colors.white70,
              child: Center(
            child: Text(title, textScaleFactor: 1.5, style: TextStyle(
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
              subtitle: new Row(children: <Widget>[
                Icon(Icons.place,
                color:Colors.blueGrey,
                size: 16.0, ),
                Text(
                hospital.location
              ),
              ],),
                

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

  Widget build(context){
    return new Scaffold(
      appBar: AppBar(
      title: Text("Search Hospitals"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search),
          onPressed: (){
            showSearch(context: context, delegate: new DataSearch(_hospitals,allhospitalsName ));
          },
        )
        
      ],
    ),
      backgroundColor: Colors.white,
      body: _buildBody(),

    );
  }


}


class DataSearch extends SearchDelegate<String>{
  List<Hospitals> _hospitals;
  List<Hospitals> searchedHospitals;
  List<String> allHospitalName;
  DataSearch(this._hospitals, this.allHospitalName);
  var  img;
  var name;
  var location;
  bool loading = true;


  final recentHospitals = [
      "caoish fjgh",
      "aoisfh  ivn",
    ]; 

  
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




    @override
    List<Widget> buildActions(BuildContext context){
      
      //action for app bar
      return [
        IconButton(icon: Icon(Icons.clear),
        onPressed: (){          
          query = "";
        },)
      ];
    }


    @override
    Widget buildLeading(BuildContext context){

      //leading icon on the left of the app bar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        },
      );

    }



  getHospital(String hospital_name) async{
  //  _hospitals.where((hospitalName) => hospitalName.name.toLowerCase().contains(hospital_name.toLowerCase()).toList();
    //var hospital = _hospitals.where((hospital) => hospital.name == hospital_name);
    final api = await Api.getApi();
    final List<Hospitals> searchedHospitals = await api.getHospital(hospital_name);
    print(searchedHospitals);
    img = searchedHospitals[0].avatarUrl;
    name = searchedHospitals[0].name;
    location = searchedHospitals[0].location;
    loading = false;

  }

  Future<Null> refresh() {
    return new Future<Null>.value();

  }


 
    @override
    Widget buildResults(BuildContext context) {
       getHospital(query);
       //var hospital = _hospitals.where((hospital) => hospital.name == query);
        print(query);
      while (loading){
        return new RefreshIndicator(
        onRefresh: refresh,
        child: new ListTile(
              onTap: () =>Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new SearchedPage(query))),
              
              title: new Text(
                'tap to continue',
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
      
        ));
      

      }

      
      while(!loading){
      return ListView(
        children: <Widget>[
            new ListTile(
              onTap: () =>Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new SearchedPage(query))),
              leading:  new CircleAvatar(
                  backgroundImage: new NetworkImage(img),
                ),
              
              title: new Text(
                name,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(
                location
              ),
              isThreeLine: true,
              dense: false, 
            )
        ],

      );
    }
    }


    

    loader(BuildContext context) async{
      await new Future.delayed(new Duration(seconds: 3));
          showResults(context);   
    }


    @override
    Widget buildSuggestions(BuildContext context){
      
      //show when someon searches for something
      final suggestionList = query.isEmpty
      ? allHospitalName
      :allHospitalName.where((p) => p.startsWith(query)).toList();

      return ListView.builder(
        itemBuilder: (context,index)=> ListTile(
        onTap: (){
          loader(context);
          query = suggestionList[index];
       
        },
        leading: Icon(Icons.location_city),
        title: RichText(text: TextSpan(
          text : suggestionList[index].substring(0,query.length),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [TextSpan(
            text: suggestionList[index].substring(query.length),
            style: TextStyle(color: Colors.grey)
          )])),
      ),
      itemCount: suggestionList.length,);


  }

}
