import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'showcase_services.dart';
import 'showcase_detail.dart';
import 'showcase_picture.dart';
import 'showcase_doctors.dart';


class Hospitalshowcase extends StatefulWidget{
  final Hospitals hospital;



  Hospitalshowcase(this.hospital);

  @override
  _HospitalshowcaseState createState() => new _HospitalshowcaseState();
}

class _HospitalshowcaseState extends State<Hospitalshowcase>
  with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  

  @override
  initState(){
    super.initState();
    _tabs= [
      new Tab(text: 'Pictures'),
      new Tab(text: 'Details'),
      new Tab(text: 'Services Available'),
      new Tab(text: 'Doctors and staffs'),

    ];
    _pages = [
      new PictureShowcase(widget.hospital),
      new DetailShowcase(widget.hospital),
      new ServicesShowcase(widget.hospital),
      new DoctorShowcase(widget.hospital),
    ];

    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }


  @override
  Widget build(context){

    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TabBar(
            isScrollable: true,
            labelColor: Colors.indigo,
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.greenAccent,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),

            )
        ],
      ),
      );
    
  }
}