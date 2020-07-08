import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../services/api.dart';
import 'profile.dart';
import 'appointment.dart';
import 'diagnosis.dart';
import '../widgets/hospital_list.dart';
import '../models/patient.dart';
import '../models/news.dart';
import 'search_hospitals.dart';
import '../widgets/doctors_list.dart';
import '../widgets/color_loader.dart';
import '../widgets/patient_profile.dart';
import '../utils/routes.dart';
import 'news_detail_page.dart';
import 'favourites.dart';



class HomeScreen extends StatefulWidget{

  
  HomeScreen({this.onSignedOut});
  final VoidCallback onSignedOut;


    createState(){
    return _HomeScreenState();
  }
}




class _HomeScreenState extends State<HomeScreen>{
  int _page = 0;
  String _userEmail;
  Patient _patient;
  bool loading = true;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.blue
    ];
  List<News> _news = [];
  Api _api;
  
  String tabNo = 'Latest News and Articals';

    @override
  void initState() {
    super.initState(); 
    loadEmail();    
    loadPatient();
    loadNews();
 
  }


  loadEmail() async{

    var user = await FirebaseAuth.instance.currentUser();
    String userEmail = user.email;
    print(userEmail);
    setState(() {
          this._userEmail = userEmail;
        });
  }

  loadPatient() async{
    final api = await Api.getApi();
    final List<Patient> patient = await api.getPatient(_userEmail);
    setState(() {
          print(patient[0]);
          _patient = patient[0];
          loading = false;

        });
  } 

  loadNews() async{
    final api = await Api.getApi();
    final List<News> news = await api.getAllNews();
    setState(() {
      _api = api;
          _news = news;
          //_profileImage = new NetworkImage(api.firebaseUser.photoUrl);
        });

  }

  void _signOut() async{
    try{
      await Api.signedOut();
      widget.onSignedOut();
    } catch(e){
      print(e);
    }
  }

  void onTapped(BuildContext context,String heading){
      switch(heading){
        case ('Search Hospital'):
          {
          
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new SearchHospital()
            ));
          
          }
          break;
        case('Appointment'):
          { Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Appointment(_patient)
            ));}
          break;
        case ('Doctors'):
            { Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new DoctorsList()
            ));}
          break;
    }
  }

  Widget build(context){
    while(loading != false){
      return new Scaffold(
        body: Container(
          child: ColorLoader(colors: colors, duration: Duration(milliseconds: 1200)),
         ));

    }
    while(loading == false){
      var assetSearchImage = AssetImage("assets/search.jpg");
    Image searchImage = new Image(image: assetSearchImage, height: 75.0, width: 150.0, fit: BoxFit.fitWidth,);

    var assetAppointmentImage = AssetImage("assets/appointment.jpg");
    Image appointmentImage = new Image(image: assetAppointmentImage, height: 75.0, width: 150.0, fit: BoxFit.fitWidth,);

    var assetDiagnosisImage = AssetImage("assets/diagnosis.jpg");
    Image diagnosisImage = new Image(image: assetDiagnosisImage, height: 75.0, width: 150.0, fit: BoxFit.fitWidth,);

    Container navBar(BuildContext context,Image img,String heading){
      return Container(
                       width: 150.0,
               child: Card(
                 
                 child: Wrap(
                   children: <Widget>[
                     img,
                     ListTile(
                       title: Text(heading),  
                       onTap: () => onTapped(context, heading)                     
                       )                       
                   ],
                 ),
               )
               ,
              )
            ;
    } 


 

     final children = <Widget>[              
      navBar(context, searchImage,'Search Hospital'),   
      navBar(context,diagnosisImage,'Doctors'),           
      navBar(context, appointmentImage,'Appointment'),

      ];    
    // children.add(navBar(searchImage,'Search Hospital'));
              
    // children.add(navBar(appointmentImage,'Appointment'));
    // children.add(navBar(diagnosisImage,'Diagnosis'));
    // children.add(navBar(reportImage,'Report'));

     
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
                  backgroundImage: NetworkImage(_patient.patient_img),                
                  
                ),
                accountEmail: Text(_patient.patient_name)
            ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
              onTap: (){
                Navigator.of(context).pop();
              } ,
            ),
            new ListTile(
              title: new Text("Appointments"),
              trailing: new Icon(Icons.event_available),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Appointment(_patient)
                ));
              } ,
            ),

            new ListTile(
              title: new Text("Favourites"),
              trailing: new Icon(Icons.favorite),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Favourites(_patient)
                ));
              } ,
            ),
            new ListTile(
              title: new Text("My Account"),
              trailing: new Icon(Icons.account_box),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Profile(_patient)
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
      Icon(Icons.home, size: 30),
    ],
    onTap: (index) {
      setState(() {
        _page = index;
              tabNo = 'Latest News and Articals';

            });      //Handle button tap
    },
  ),

    body: new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
                Container(
        height: 125.0,
        child: new ListView(
           scrollDirection: Axis.horizontal,
           shrinkWrap: true,
           physics: const ClampingScrollPhysics(),
           children: children,           
         )
       ),


      Container(
              child: Center(
            child: Text(tabNo, textScaleFactor: 1.75, style: TextStyle(
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
              color: Color.fromARGB(125, 0, 0, 255),
              ),
              ],)))),

        _getListViewWidget() 
        ]))


      //]
      );

    }

}

  Widget childtab(){
  // if(tabNo == 'Profile Tab'){
    return Center(child: SingleChildScrollView(
      child: new Container(
      child: PatientProfile(patient_name:_patient.patient_name,patient_email:_patient.patient_email,patient_img:_patient.patient_img,patient_address:_patient.patient_address),

    )));
  // }
  // else{
  //   return new Container(child: Text('working on it'),);
  // }

}

  Widget _getListViewWidget(){
        return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _news.length,
          itemBuilder: _buildNewsItem,

        ),
      ));
  } 

  Widget _buildNewsItem(context, int index){
    News news = _news[index];
    return new Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: new Card(
        color: Colors.white70,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToNewsDetails(news, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(news.news_img),
                ),
              ),
              title: new Text(
                news.news_heading,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text('By: '+
                news.news_author,
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
    _reloadnews();
    return new Future<Null>.value();

  }

  _navigateToNewsDetails(News news, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder : (c) {
          return new NewsDetailPage(news, avatarTag: avatarTag);          
        },
        settings: new RouteSettings(),
      )
    );
  }

  
  _reloadnews() async{
        if (_api != null){
          final List<News> news = await _api.getAllNews();
      setState(() {
              _news = news;
            });
          
    }



  }
}
  

