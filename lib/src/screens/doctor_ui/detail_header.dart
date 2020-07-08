import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catbox/src/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
//import 'doctor_image.dart';
import 'package:intl/intl.dart';
import 'package:catbox/src/services/api.dart';
import '../../widgets/top_layout.dart';
import '../../models/hospital.dart';
import '../../models/appointment_pending.dart';
import '../../models/appointment_confirmed.dart';
import 'package:url_launcher/url_launcher.dart';


class DoctorDetailHeader extends StatefulWidget{
  final Doctors doctor;
  final Object avatarTag;
  

  DoctorDetailHeader(
    this.doctor, {
    @required this.avatarTag,
    } 
  );

  @override
  _DoctorDetailHeaderState createState() => new _DoctorDetailHeaderState();
}

class _DoctorDetailHeaderState extends State<DoctorDetailHeader>{
  static const BACKGROUND_IMAGE = 'assets/doctorbg.jpg';
  bool _hasAppointment = false;
  bool _isPendingAppointment = false;
  String doctorId;
  String patientId;
  FirebaseUser patient;
  String appointmentCheck = "";
  String doctorName;
  String hospitalName;
  String timeOfAppointment;
  String datetimeAppointed;
  DateTime selected;
  Future<Api> _api;
  static DateTime now = DateTime.now();

  @override
  void initState(){
    super.initState();
    doctorId = widget.doctor.doctor_id;
    doctorName = widget.doctor.doctor_name;
    getPatientId();
    _api = Api.getApi();
    checkAppointmentState();
    print(doctorName);
    print(hospitalName);
    print(timeOfAppointment);
    datetimeAppointed = new DateFormat("dd/MM/yyyy").format(now); 
  }
  void getPatientId() async{
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();    
    setState(() {
      patientId = currentUser.uid;  
    });
    
    
  }

  
  void checkAppointmentState() async{
    final api = await _api;
    final List<AppoinmentConfirmed> appointment_confirmed = await api.getConfirmedAppointments(patientId,doctorId);
    final List<AppoinmentPending> appointment_pending = await api.getPendingAppointments(patientId,doctorId);
    
     

    if (appointment_confirmed.length != 0){
      final List<Hospitals> getHospital = await api.getHospitalFromDoc(appointment_confirmed[0].hospital_id);
      print(appointment_confirmed[0].hospital_id);

      
      setState(() {
        _hasAppointment = true;
        appointmentCheck = 'See Appointment';
        hospitalName = getHospital[0].name;
        timeOfAppointment = appointment_confirmed[0].time_of_appointment; 
        
      });
        
    }else{
      if(appointment_pending.length != 0){
      setState(() {
        _isPendingAppointment = true; 
        appointmentCheck = 'Appointment Pending';
      });
      }else{
        setState(() {
        _isPendingAppointment = true; 
        appointmentCheck = 'set Appointment';
              });
      }
      
        
    }
  }



  @override
  Widget build(context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

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

    var diagonalBackground = new DiagonallyColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
        color: const Color(0xBB42A5F5),

    );

    var avatar = new Hero(
      tag: widget.avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(widget.doctor.doctor_img),
        radius: 75.0,
      ),

    );

    
    
    var actionButtons = new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            new ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: new MaterialButton(
              minWidth: 140.0,
              color: theme.accentColor,
              textColor: Colors.white,
              onPressed: _launchcaller,
              child: new Text('Contact Now'),
            ),
          ),
          new ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: new MaterialButton(
              minWidth: 140.0,
              color: theme.accentColor,
              textColor: Colors.white,
              onPressed:() async {
                  await new Future.delayed(const Duration(seconds: 1)); 
                  _handlePressed(appointmentCheck);

              } ,
              child: new Text(appointmentCheck),
            ),
          ),        
        ],
      ),
    );

    return new Stack(
      children: [
        diagonalBackground,
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: [
              avatar, 
              actionButtons,
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );    
  
  }

  void _handlePressed(String appointmentCheck) async{     
    switch(appointmentCheck){
      case('Appointment Pending'):
      {
        var onCancle =
          _cancle_appointment;
        
        pendingDialogue1(context, onCancle).then((_){
        print('value is cancle appointment');
        });
      }
      break;
      case('See Appointment'):
      {
        pendingDialogue2(context).then((_){
        print('value is See Appointment');
        });
      }
      break;
      case('set Appointment'):
      {
        setAppointmentDialogue(context).then((_){
        print('value is set Appointment');
        });

      }
    }
  }

  _cancle_appointment() async{
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
          Firestore.instance.collection('appointment_pending')
          .where('patient_id', isEqualTo: firebaseUser.uid)          
          .where('doctor_id', isEqualTo: widget.doctor.doctor_id)
          .getDocuments()
          .then((docs){
            print(docs.documents[0].documentID);
            Firestore.instance.document('/appointment_pending/${docs.documents[0].documentID}')
            .delete();
              
          });  
        _reloadpage();   

    }

  Future<Null> setAppointmentDialogue(BuildContext context){
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

    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text('Set Appointment'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.date_range,
                color: Colors.black,
              ),
              onPressed: () => _showDateTimePicker(),
            ),
            new FlatButton(
              child: const Text('ok'),
              onPressed: add_appointment_pending              
            ),
            new FlatButton(
              child: const Text('Cancle'),
              onPressed: (){
                Navigator.of(context).pop();
              
              },            
            ),

          ],

        );
      }
    );
  }

  _reloadpage() async{
    if (_api != null){
      checkAppointmentState();
    
  }
  }

  add_appointment_pending() async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('appointment_pending').document()
      .setData({'patient_id' : firebaseUser.uid,'doctor_id': widget.doctor.doctor_id , 'pending_date': datetimeAppointed});   
    _reloadpage();      
    Navigator.of(context).pop();

    }

  _showDateTimePicker() async {
    selected = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );
        setState(() {
          datetimeAppointed = new DateFormat("dd/MM/yyyy").format(selected);          
        });
  }



  Future<Null> pendingDialogue1(BuildContext context, void onCancle()){
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text('Please Wait..Your appointment is pending..'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: const Text('Cancle Appointment'),
              onPressed: (){
                Navigator.of(context).pop();
                onCancle();
              },
            )
          ],

        );
      }
    );
  }

  Future<Null> pendingDialogue2(BuildContext context){
    print(doctorName);
    print(hospitalName);
    print(timeOfAppointment);
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: new Text('You have an appointment with $doctorName in $hospitalName at $timeOfAppointment'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      }
    );
  }

  _launchcaller()  async  {
    var url = 'tel:'+ widget.doctor.doctor_contactNo ;

    if (await canLaunch(url)) 
    {
      await launch(url);
    }

    else{
      throw 'Could not launch $url';
    }

  }


}