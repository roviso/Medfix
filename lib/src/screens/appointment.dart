import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:catbox/src/models/doctor.dart';
import '../models/patient.dart';
import '../models/appointment_confirmed.dart';
import '../models/appointment_pending.dart';
import '../screens/doctor_ui/doctor_page.dart';
import '../utils/routes.dart';
import 'home_screen.dart';
import 'profile.dart';

import '../widgets/dot_loader.dart';
import '../widgets/dot_type.dart';

import 'favourites.dart';

class Appointment extends StatefulWidget{
    final Patient patient;
  

  Appointment(this.patient);


  

  createState(){
    return _AppointmentState();
  }
}


class _AppointmentState extends State<Appointment>{
  int _page = 0;
  String tabNo = 'Current Appointments';
  static DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  DateTime selected;

  List<Doctors> _doctors = [];
  List<Doctors> _hasAppointmentdoctors = [];
    List<Doctors> _hasPendingAppointmentdoctors = [];
  List<AppoinmentConfirmed> _appointmentConfirmed = [];
  List<AppoinmentPending> _appoinmentPending = [];
  List<String> appointmentDocId = [];
  List<String> pendingAppointmentDocId = [];

    Api _api;
    bool loading_appointment_pending = true;
    bool loading_appointment_confirmed = true;

  @override
  void initState(){
    super.initState();
    _loadAppointmentConfirmed().then((_){
      for (String docId in appointmentDocId){
        for( int i = 0 ; i< _doctors.length; i++){
          if(_doctors[i].doctor_id == docId){
            _hasAppointmentdoctors.add(_doctors[i]);
          }
        }
      }
    });

    _loadAppointmentPending().then((_){
      for (String docId in pendingAppointmentDocId){
        for( int i = 0 ; i< _doctors.length; i++){
          if(_doctors[i].doctor_id == docId){
            _hasPendingAppointmentdoctors.add(_doctors[i]);
          }
        }
      }

    });

  }


    _loadAppointmentConfirmed() async{
    final api = await Api.getApi(); 
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final List<Doctors> doctors = await api.getAllDoctors();
    List<AppoinmentConfirmed> appointmentConfirmed = await api.getAppointmentConfirmed(firebaseUser.uid);
    setState(() {
      _api = api;
      _doctors = doctors;
      appointmentConfirmed.forEach((element) => appointmentDocId.add(element.doctor_id));
      _appointmentConfirmed = appointmentConfirmed;
      loading_appointment_confirmed = false;

    });

    }

    _loadAppointmentPending() async{
    final api = await Api.getApi(); 
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final List<Doctors> doctors = await api.getAllDoctors();
    List<AppoinmentPending> appointmentPending = await api.getAppointmentPending(firebaseUser.uid);
    setState(() {
      _api = api;
      _doctors = doctors;
      appointmentPending.forEach((element) => pendingAppointmentDocId.add(element.doctor_id));
      _appoinmentPending = appointmentPending;
      loading_appointment_pending = false;

    });

  }

  _showDateTimePicker() async {
    selected = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
        setState(() {});
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

  
  Future<Null> refresh() {
    // _reloaddoctors();
    return new Future<Null>.value();

  }

  Widget _getPostAppointments(){
    while (loading_appointment_confirmed != false){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
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
    while (loading_appointment_confirmed == false){
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _hasAppointmentdoctors.length,
          itemBuilder: _buildPostAppointmentdoctorItem,

        ),
      ),
      );
    }
  } 

    Widget _buildPostAppointmentdoctorItem(context, int index){
    String appointedDate;
    Doctors doctor = _hasAppointmentdoctors[index];
    DateTime datetimeAppointed;
    String datetimeAppointed_2;

    for (int i = 0; i < _appointmentConfirmed.length; i++){
      if(_appointmentConfirmed[i].doctor_id == doctor.doctor_id){
        appointedDate = _appointmentConfirmed[i].time_of_appointment;  
        datetimeAppointed = new DateFormat("dd/MM/yyyy").parse(appointedDate);
        datetimeAppointed_2 = new DateFormat("dd MMMM yyyy").format(datetimeAppointed);
      }
    }
    

    if(datetimeAppointed.isBefore(now)){
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
              subtitle: Text(doctor.doctor_hospital),
              trailing: Container(
                width: 75.0,
                    child: Text(datetimeAppointed_2,
                //datetimeAppointed.year.toString() + datetimeAppointed.month.toString() + datetimeAppointed.day.toString(),
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
 
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );

    }else{
      return Text('');
    }

  }


  Widget _getUpcomingAppointments(){
    while (loading_appointment_confirmed!= false){
      return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          SizedBox(height: 200.0,),
         // _getAppTitleWidget(),
         Center(
           child:ColorLoader5(
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
    
  while(loading_appointment_confirmed == false){
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _hasAppointmentdoctors.length,
          itemBuilder: _buildConfirmedAppointmentdoctorItem,

        ),
      ),
      );
    }
  } 


  
  Widget _buildConfirmedAppointmentdoctorItem(context, int index){
    String appointedDate;
    Doctors doctor = _hasAppointmentdoctors[index];
    DateTime datetimeAppointed;
    String datetimeAppointed_2;

    for (int i = 0; i < _appointmentConfirmed.length; i++){
      if(_appointmentConfirmed[i].doctor_id == doctor.doctor_id){
        appointedDate = _appointmentConfirmed[i].time_of_appointment;  
        datetimeAppointed = new DateFormat("dd/MM/yyyy").parse(appointedDate);
         datetimeAppointed_2 = new DateFormat("dd MMMM yyyy").format(datetimeAppointed);

      }
    }
    if(datetimeAppointed.isAfter(now)){
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
              subtitle: Text(doctor.doctor_hospital),
              trailing: Container(
                width: 75.0,
                    child: Text(datetimeAppointed_2,
                //datetimeAppointed.year.toString() + datetimeAppointed.month.toString() + datetimeAppointed.day.toString(),
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
 
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );}
    else{
      return SizedBox.shrink();
    }
  }


  
  Widget _getPendingAppointments(){
    while (loading_appointment_pending != false){
                return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
      child: new Column(
        children: <Widget>[
          SizedBox(height: 200.0,),
         // _getAppTitleWidget(),
         Center(
           child:ColorLoader5(
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
    while (loading_appointment_pending == false){
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _hasPendingAppointmentdoctors.length,
          itemBuilder: _buildPendingAppointmentdoctorItem,

        ),
      ),
      );
    }
  } 


  
  Widget _buildPendingAppointmentdoctorItem(context, int index){
    Doctors doctor = _hasPendingAppointmentdoctors[index];

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
              subtitle: Text(doctor.doctor_hospital),
              trailing: Container(
                width: 75.0,
                    child: Text("Waiting..",
                //datetimeAppointed.year.toString() + datetimeAppointed.month.toString() + datetimeAppointed.day.toString(),
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
 
              isThreeLine: true,
              dense: false,
            )
          ],

        )
      )
    );
  }

  Widget build(context){
     var dateFormat_1 = new Column(
      children: <Widget>[
        new SizedBox(
          height: 30.0,
        ),
        selected != null
            ? new Text(
                new DateFormat('dd/MM/yyyy').format(selected),
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              )
            : new SizedBox(
                width: 0.0,
                height: 0.0,
              ),
      ],
    );


    return Scaffold(appBar: AppBar(
      title: Text('Appointments'),
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
                // Navigator.of(context).push(new MaterialPageRoute(
                //   builder: (BuildContext context) =>
                //     new Profile(_patient)
                // ));
              } ,
            ),

            new ListTile(
              title: new Text("Favourites"),
              trailing: new Icon(Icons.favorite),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new Favourites(widget.patient)
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
          Icon(Icons.add, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
                if(_page == 0){
                  tabNo = 'Current Appointments';
                }else if(_page == 1){
                  tabNo = 'Set Appointments';
                }
                });      //Handle button tap
        },
        
      ), 
      body:  _body()  
    );
  }


  Widget _body(){

    while(tabNo == 'Current Appointments'){
    return new Container(
        margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
        child: new Column(
          children: <Widget>[
          title('Upcoming Appointments'),
          _getUpcomingAppointments(),
          title('Post Appointments'),
          _getPostAppointments(),


          ],
        ),
      );
    }

    while(tabNo == 'Set Appointments'){
    return new Container(
        margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
        child: new Column(
          children: <Widget>[
          title('Pending Appointments'),
          _getPendingAppointments(),
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


  
    void _signOut() async{
    try{
      await Api.signedOut();
    } catch(e){
      print(e);
    }
  }


  //   Future<Null> setAppointmentDialogue2(BuildContext context){
  //   return showDialog<Null>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context){
  //       return new AlertDialog(
  //         title: new Text('Set Appointment'),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: const Text('ok'),
  //             onPressed: (){
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],

  //       );
  //     }
  //   );
  // }
  




}
    

            //     new IconButton(
            //   icon: new Icon(
            //     Icons.date_range,
            //     color: Colors.black,
            //   ),
            //   onPressed: () => _showDateTimePicker(),
            // ),
            // dateFormat_1,
  
