import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../services/api.dart';
import '../services/searchservice.dart';
import 'package:catbox/src/models/hospital.dart';
import '../widgets/hospital_searchList.dart';

import 'hospital_profile.dart';

class Diagnosis extends StatefulWidget{
  

  createState(){
    return _DiagnosisState();
  }
}


class _DiagnosisState extends State<Diagnosis>{

  List<Hospitals> queryResultSet = [];
  List<Hospitals> _searchedhospitals = [];
  List<Hospitals> tempSearchStore = [];
  List<Hospitals> allhospitals = [];
  List allhospitalsName = [];
  List searchedhospitalsName = [];
  Api _api;


  @override
  void initState(){
    super.initState();
     _loadFromFirebase1();
     allhospitals.forEach((element) =>
        allhospitalsName.add(element.name));

  }

  _loadFromFirebase1() async{
    final api = await Api.getApi();
    final List<Hospitals> hospitals = await api.getAllHospitals();
    setState(() {
          _api = api;
          allhospitals = hospitals;
          //_profileImage = new NetworkImage(api.firebaseUser.photoUrl);
        });

  }

  _loadFromFirebase(String value) async{
    final api = await Api.getApi();
    final List<Hospitals> hospitals = await api.searchHospitals(value);
    setState(() {
          _api = api;
          _searchedhospitals = hospitals;
          //_profileImage = new NetworkImage(api.firebaseUser.photoUrl);
          _searchedhospitals.forEach((element) =>
       searchedhospitalsName.add(element.name));
           print(searchedhospitalsName);
        });

  }

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
              queryResultSet = [];
              tempSearchStore = [];

            });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);




  if (queryResultSet.length == 0 && value.length == 1) {
      _loadFromFirebase(value);
      // SearchService().searchByName(value).then((QuerySnapshot docs) {
      //   for (int i = 0; i < docs.documents.length; ++i) {
      //     queryResultSet.add(docs.documents[i].data);
      //   } 
      // });
    } else {
      tempSearchStore = [];
      _searchedhospitals.forEach((element) {
        if (element.name.startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }


  }



  Widget build(context){
    //_hospitals.forEach((element) => allhospitalsName.add(element.name));


  return Scaffold(
    appBar: AppBar(
      title: Text("Search Hospitals"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search),
          onPressed: (){
            //showSearch(context: context, delegate: DataSearch());
          },
        )
        
      ],
    ),
    drawer: Drawer(),
      body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
      //                   tempSearchStore.forEach((element) =>
      //  searchedhospitalsName.add(element.name));
      //  print(searchedhospitalsName);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          // GridView.count(
          //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 4.0,
          //     mainAxisSpacing: 4.0,
          //     primary: false,
          //     shrinkWrap: true,
          //     children: tempSearchStore.map((element) {
          //       return buildResultCard(element);
          //     }).toList())
           HospitaSearchlList(tempSearchStore),

        ]
        ) 
        );
        
  }

  Widget buildResultCard(data) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: Center(
        child: Text(data['name'],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        )
      )
    )
  );
}

}


// class DataSearch extends SearchDelegate<String>{
//  // List allhospitalsName = [];
//   get_hospitalName() async{
//     List<Hospitals> _hospitals = [];

//     Api _api;

//     final api = await Api.getApi();
//     final List<Hospitals> hospitals = await api.getAllHospitals().then((value){
//         _hospitals = value;
//     });
//         _hospitals.forEach((element) =>
//       allhospitalsName.add(element.name));
//   }


//     final recentHospitals = [
//       "caoish fjgh",
//       "aoisfh  ivn",
//     ];
//     @override
//     List<Widget> buildActions(BuildContext context){
//       //get_hospitalName();
//       //action for app bar
//       return [
//         IconButton(icon: Icon(Icons.clear),
//         onPressed: (){
//           query = "";
//         },)
//       ];

//     }


//     @override
//     Widget buildLeading(BuildContext context){
//       //leading icon on the left of the app bar
//       return IconButton(
//         icon: AnimatedIcon(
//           icon: AnimatedIcons.menu_arrow,
//           progress: transitionAnimation,
//         ),
//         onPressed: (){
//           close(context, null);
//         },
//       );

//     }




//     @override
//     Widget buildResults(BuildContext context){
//       //show some result based on the selection
//       return Container(
//         height: 200,
//         width: 200,
//         child: Card(
//         color: Colors.red,
//         shape: StadiumBorder(),
//         child: Center(
//           child: Text(query),
//         ),
//       ));
//       //return HospitaSearchlList(hospital)
      


//     }

//     @override
//     Widget buildSuggestions(BuildContext context){
//       //show when someon searches for something
//       final suggestionList = query.isEmpty
//       ? Appointment.widget.allhospitalsName
//       :allhospitalsName.where((p) => p.startsWith(query)).toList();

//       return ListView.builder(
//         itemBuilder: (context,index)=> ListTile(
//         onTap: (){
//           query = suggestionList[index];
//           showResults(context);          
//         },
//         leading: Icon(Icons.location_city),
//         title: RichText(text: TextSpan(
//           text : suggestionList[index].substring(0,query.length),
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           children: [TextSpan(
//             text: suggestionList[index].substring(query.length),
//             style: TextStyle(color: Colors.grey)
//           )])),
//       ),
//       itemCount: suggestionList.length,);


//   }



// }
    
  
