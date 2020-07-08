import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../header/hospital_image.dart';
import 'package:catbox/src/services/api.dart';
import 'package:catbox/src/widgets/top_layout.dart';


class HospitalDetailHeader extends StatefulWidget{
  final Hospitals hospital;





  HospitalDetailHeader(
    this.hospital,

  );

  @override
  _HospitalDetailHeaderState createState() => new _HospitalDetailHeaderState();
}

class _HospitalDetailHeaderState extends State<HospitalDetailHeader>{
  static const BACKGROUND_IMAGE = 'assets/hospital-background.jpg';
  bool _likeDisabled = true;
  String _likeText = "";
  int _likeCounter = 0;
  StreamSubscription _watcher;
  var contactNo = '';


  Future<Api> _api;

  @override
  void initState(){
    super.initState();
    _likeCounter = widget.hospital.likeCounter;
    _api = Api.getApi();
    updateLikeState();
    contactNo = widget.hospital.contactNo;
  }

  void likeCat() async{
    final api = await _api;
    if(await api.hasLikedHospital(widget.hospital)){
      api.unlikeHospital(widget.hospital);
      setState(() {
              _likeCounter -= 1;
              _likeText = 'LIKE';
            });   
    } else {
      api.likeHospital(widget.hospital);
      setState((){
        _likeCounter += 1;
        _likeText = 'UN-Like';
      });
    }
  }

  void updateLikeState() async{
    final api = await _api;
    _watcher = api.watch(widget.hospital, (hospital){
      if(mounted) {
        setState(() {
          _likeCounter = hospital.likeCounter;
        });
      }
    });

    bool liked = await api.hasLikedHospital(widget.hospital);
    if(mounted) {
      setState(() {
        _likeDisabled = false;
        _likeText = liked? "UN-Like":"LIKE";
      });
    }
  }

  @override
  void dispose(){
    if (_watcher != null){
      _watcher.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

    var diagonalBackground = new DiagonallyColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB42A5F5),
    );

    var avatar =  new CircleAvatar(
        backgroundImage: new NetworkImage(widget.hospital.avatarUrl),
        radius: 75.0,
  

    );

    var likeInfo = new Padding(
      padding: const EdgeInsets.only(top: 13.0) ,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.thumb_up,
            color: Colors.blue,
            size: 13.0,
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Text(
              _likeCounter.toString(),
              style: textTheme.subhead.copyWith(color: Colors.blue),
            ),

          )
        ],
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
            child: new RaisedButton(
              color: Colors.lightGreen,
              disabledColor: Colors.grey,
              textColor: Colors.white,
              onPressed: _likeDisabled? null: likeCat,
              child: new Text(_likeText),

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
              likeInfo,
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
  _launchcaller()  async  {
    var url = 'tel:'+contactNo ;

    if (await canLaunch(url)) 
    {
      await launch(url);
    }

    else{
      throw 'Could not launch $url';
    }

  }
}