import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catbox/src/models/doctor.dart';
import 'package:catbox/src/models/doctor_favourite.dart';
import '../services/api.dart';
import '../utils/routes.dart';
import '../screens/doctor_ui/doctor_page.dart';
import '../screens/doctor_ui/searchedDoctor/searched_page.dart';
import '../widgets/dot_loader.dart';
import 'dot_type.dart';

  
class DoctorsList extends StatefulWidget{

  _DoctorsListState createState() => new _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList>{
   List<Doctors> _doctors = [];
   List<Doctors> _specificDoctors = [];
  List<String> alldocotrsName = [];
  List<DoctorFavourite> _favouriteList =[];
  List<String> favDocId = [];
    String specialty = 'Anesthesiologist';
    bool loading = true;
    bool isFavourite = false; 

  Api _api;

  @override
  void initState(){
    super.initState();
    _loadFromFirebase();

  }

  _loadFromFirebase() async{
    final api = await Api.getApi(); 
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final List<Doctors> doctors = await api.getAllDoctors();
    List<Doctors> specificDoctors = await api.getSpecificDoctors(specialty);
    List<DoctorFavourite> favouriteList = await api.getDoctorFavourite(firebaseUser.uid);
    setState(() {
      _api = api;
      _doctors = doctors;
      _favouriteList = favouriteList;
      _doctors.forEach((element) => alldocotrsName.add(element.doctor_name));
      favouriteList.forEach((element) => favDocId.add(element.doctor_id));
      _specificDoctors = specificDoctors;
      loading = false;

    });

  }

  _reloaddoctors() async{
    if (_api != null){
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      final List<Doctors> doctors = await _api.getAllDoctors();
      List<Doctors> specificDoctors = await _api.getSpecificDoctors(specialty);
      List<DoctorFavourite> favouriteList = await _api.getDoctorFavourite(firebaseUser.uid);
      
      setState(() {
              _doctors = doctors;
              _specificDoctors = specificDoctors;
              favouriteList.forEach((element) => favDocId.add(element.doctor_id));
              
              loading = false;
            });
    }
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


  Widget build(context){

    
    return new Scaffold(      
      appBar: AppBar(
      title: Text("Search Doctors"),
      // actions: <Widget>[
      //   IconButton(icon: Icon(Icons.search),
      //     onPressed: (){
      //       showSearch(context: context, delegate: new DataSearch(_doctors,alldocotrsName ));
      //     },
      //   )
        
      // ],
    ),
      backgroundColor: Colors.white,
      body: _buildBody(),

    );
  
  }
    
  Widget _buildBody() {
    while(loading != false){
          return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          _getFilterbar(),
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
          _getFilterbar(),
         // _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }
  }
  Widget _getFilterbar(){
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        specialtyOption(),        
        filter(),    

      ],
    );

  }


  var _specialty = ['Anesthesiologist','Adolescent Medicine ','Allergy & Immunology','Cardiothoracic Radiology ','Cardiovascular Disease','Colon & Rectal Surgery',
        'Dermatology','Endocrinology, Diabetes & Metabolism','Family medicine physician','Forensic pathologist','Gastroenterologist','Gynecologist',
        'Gynecologic oncologist','Hand surgeon','Infectious disease specialist','Interventional cardiologist','Medical examiner','Nephrologist','Neurological surgeon'
        ,'Neurologist','Obstetrician','Oncologist','Ophthalmologist','Oral surgeon (maxillofacial surgeon)','Otolaryngologist (ear, nose, and throat specialist)','Pathologist',
        'Pediatrician','Perinatologist','Physiatrist','Plastic surgeon','Psychiatrist','Pulmonologist','Radiation oncologist','Radiologist','Reproductive endocrinologist','Sleep disorders specialist',
        'Spinal cord injury specialist','Sports medicine specialist','Surgeon','Thoracic surgeon','Urologist','Vascular surgeon'];
  var _currentSpecialty = 'Anesthesiologist';

  Widget specialtyOption(){
    return Container(child:     DropdownButton<String>(
      items: _specialty.map((String dropDownStringItem){
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: SizedBox(
            width: 200.0,
            child: Text(dropDownStringItem,
            overflow: TextOverflow.ellipsis,),
            
          )
           
        );
      }).toList(),

      onChanged: (String newValueSelected) async{
        
          Api api = await Api.getApi(); 
          final List<Doctors> specificDoctors = await api.getSpecificDoctors(specialty);
          
          setState(() {            
          this._currentSpecialty = newValueSelected;
          specialty = newValueSelected;
          //_specificDoctors = specificDoctors;
          loading = true;
         // _specificDoctors = specificDoctors;
                });      
        _reloaddoctors();
        
          
      },
      value: _currentSpecialty,      
      )
    ,);

  }

  Widget filter(){
    return Row(
    children: <Widget>[
    Icon(Icons.filter_list),

    Text('  Filter',
    style: new TextStyle(
      fontSize: 20.0,
    fontWeight: FontWeight.bold,
    ),
    )

      ],
    );

  }


  Widget _getListViewWidget(){
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _specificDoctors.length,
          itemBuilder: _builddoctorItem,

        ),
      ),
      );
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
  hospitalname(Doctors doctor){
    return Expanded(
      child:Text(doctor.doctor_hospital,
      overflow: TextOverflow.fade,)

    );
    

  }

  removeFav(Doctors doctor) async{
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
          Firestore.instance.collection('doctor_favourite')
          .where('patient_id', isEqualTo: firebaseUser.uid)          
          .where('doctor_id', isEqualTo: doctor.doctor_id)
          .getDocuments()
          .then((docs){
            print(docs.documents[0].documentID);
            Firestore.instance.document('/doctor_favourite/${docs.documents[0].documentID}')
            .delete();
              
          });  
        _reloaddoctors();      
    }

    
      

    

  addFav(Doctors doctor) async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('doctor_favourite').document()
      .setData({'patient_id' : firebaseUser.uid,'doctor_id': doctor.doctor_id});
      favDocId.add(doctor.doctor_id);
    _reloaddoctors();
          


    }

  

  favIcon(Doctors doctor){
    var fav;
    if (favDocId.contains(doctor.doctor_id)){
      fav = true;
      
    }else{
      fav = false;
    }
    print(fav);
    while(fav != true){
      return InkWell(
        child: new Icon(
          Icons.favorite,
          size: 30.0,
          color: Colors.white,
          ),
        onTap:(){
          addFav(doctor);
        }
      );

    }
    while(fav == true){
      print(doctor.doctor_id);
      return InkWell(
      child: new Icon(
        Icons.favorite,
        size: 30.0,
        color: Colors.red,
        ),
      onTap:(){
        removeFav(doctor);
      }
    );
    } 

  }




  Widget _builddoctorItem(context, int index){
    Doctors doctor = _specificDoctors[index];
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
    _reloaddoctors();
    return new Future<Null>.value();

  }






}



class DataSearch extends SearchDelegate<String>{
  List<Doctors> _doctors;
  List<Doctors> searchedDoctors;
  List<String> allDoctorsName;
  DataSearch(this._doctors, this.allDoctorsName);
  var  img;
  var name;
  var location;
  bool loading = true;


  final recentdoctors = [
      "caoish fjgh",
      "aoisfh  ivn",
    ]; 

  
  _navigateTodoctorDetails(BuildContext context,Doctors doctor, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder : (c) {
          return new DoctorDetailPage(doctor, avatarTag: avatarTag);          
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



  getdoctor(String doctor_name) async{
  //  _doctors.where((doctorName) => doctorName.name.toLowerCase().contains(doctor_name.toLowerCase()).toList();
    //var doctor = _doctors.where((doctor) => doctor.name == doctor_name);
    final api = await Api.getApi();
    final List<Doctors> searcheddoctors = await api.getDoctor(doctor_name);
    print(searcheddoctors);
    img = searcheddoctors[0].doctor_img;
    name = searcheddoctors[0].doctor_name;
    location = searcheddoctors[0].doctor_specialty;
    loading = false;

  }

  Future<Null> refresh() {
    return new Future<Null>.value();

  }


 
    @override
    Widget buildResults(BuildContext context) {
       getdoctor(query);
       //var doctor = _doctors.where((doctor) => doctor.name == query);
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
      ? allDoctorsName
      :allDoctorsName.where((p) => p.startsWith(query)).toList();

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

