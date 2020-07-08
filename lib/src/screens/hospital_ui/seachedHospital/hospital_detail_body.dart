import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalDetailBody extends StatelessWidget{
  final Hospitals hospital;

  HospitalDetailBody(this.hospital);



  _createCircleBadge(IconData iconData, Color color){
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,

        ),
        radius: 16.0,
      ),
    );
  }



  @override
  Widget build(context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var locationInfo = new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color:Colors.blueGrey,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            hospital.location,
            style: textTheme.subhead.copyWith(color: Colors.blueGrey),
          ),
        )
      ],

    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          hospital.name,
          style: textTheme.headline.copyWith(color: Colors.blueGrey),

        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: locationInfo,
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text('Contact No:' +
            hospital.contactNo,
            style: textTheme.body1.copyWith(color: Colors.blueGrey, fontSize:16.0),
          ),
        ),
          new InkWell(
          onTap: _launchurl,
          child: new Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: new Row(children: <Widget>[
    
            Text('Our Website: ',
            style: textTheme.body1.copyWith(color: Colors.blueGrey, fontSize:16.0), ),
                Expanded( child:
            
            Text(
            hospital.website_url,
            style: textTheme.body1.copyWith(color: Colors.redAccent, fontSize:16.0,), ),)



            ],)

          ,
          ),
        ),

        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.share, theme.accentColor),
              _createCircleBadge(Icons.phone, Colors.brown),
              _createCircleBadge(Icons.email, Colors.blue),
            ],
          ),
        )
      ],
    );

  }

  _launchurl()  async  {
    var url = 'http:'+ hospital.website_url ;

    if (await canLaunch(url)) 
    {
      await launch(url);
    }

    else{
      throw 'Could not launch $url';
    }

  }
}