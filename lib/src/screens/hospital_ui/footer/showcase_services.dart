import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final dynamic servicesLookup = {
  "Maternity": {"name": "Maternity", "icon": IconData(0xe900, fontFamily: 'short_term_hospitalization')},
  "Surgery": {"name": "Surgery", "icon": FontAwesomeIcons.cut},
  "Nursing": {"name": "Nursing", "icon": FontAwesomeIcons.eyeDropper},
  "Emergency Care": {"name": "Emergency Care", "icon": FontAwesomeIcons.ambulance},
  "short-term hospitalization": {"name": "short-term hospitalization", "icon": new IconData(0xe900, fontFamily: 'short_term_hospitalization')},
  "emergency room services": {"name": "emergency room services", "icon": FontAwesomeIcons.ambulance},
  "general and specialty surgical services": {"name": "general and specialty surgical services", "icon": FontAwesomeIcons.ambulance},
  "x ray/radiology services": {"name": "x ray/radiology services", "icon": FontAwesomeIcons.cut},
  "laboratory services": {"name": "laboratory services", "icon": FontAwesomeIcons.cut},
  "blood services": {"name": "blood services", "icon": FontAwesomeIcons.cut},
  "home nursing services": {"name": "home nursing services", "icon": FontAwesomeIcons.cut},

  
};


class ServicesShowcase extends StatelessWidget{
  final Hospitals hospital;

  ServicesShowcase(this.hospital);

  _createCircleBadge(
    IconData iconData, Color bgColor, Color iconColor, String text) {
      return new Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: new Stack(
          children: <Widget>[
            new CircleAvatar(
              backgroundColor: bgColor,
              child: new Icon(
                iconData,
                color: iconColor,
                size: 36.0,
              ),
              radius: 36.0,
            ),
            new Positioned(
              child: new Text(
                text,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  color: iconColor,
                ),
              ),
            ),
          ],
        )
      );
  }



  @override
  Widget build(BuildContext context){
    var items = <Widget>[];

    for (var i = 0; i< hospital.services.length; i ++){
      var badge = _createCircleBadge(
        servicesLookup[hospital.services[i]]['icon'],
        Colors.white,
        Colors.blueGrey,
        servicesLookup[hospital.services[i]]['name'],
      );

      items.add(badge);
    }

    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return new GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: items,
    );

  }

}