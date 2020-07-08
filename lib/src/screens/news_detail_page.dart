import 'package:catbox/src/models/hospital.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../models/news.dart';

class NewsDetailPage extends StatefulWidget{
  final News news;
  final Object avatarTag;

  NewsDetailPage(
    this.news, {
    @required this.avatarTag,
    }
  );

  @override
  _NewsDetailPageState createState() => new _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage>{
  @override
  Widget build(context){


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Latest News and Articles'),
      ),

      body: new SingleChildScrollView(
        
       child: new Container(
         margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
         child: Column(
         
         children: <Widget>[
           heading(),
           SizedBox(height: 10),
           subheading(),
           SizedBox(height: 10),
           body(),

         ],



       ),
       ) ,
      )
    );
    
  }
  Widget heading(){
    return Column(
      children: <Widget>[
        Text(widget.news.news_heading,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0),
          textAlign: TextAlign.justify),
        Text('By: ' + widget.news.news_author,
          style: TextStyle(fontSize: 14.0),
          textAlign: TextAlign.left)


      ],
    ); 

  }

  Widget subheading(){
    return Center(      
      child: Text(widget.news.news_subheading,
          style: TextStyle(fontStyle: FontStyle.italic ,fontSize: 14.0),
          textAlign: TextAlign.justify),
      
    );

  }

  Widget body(){
    return Column(
      children: <Widget>[
        Image(image: NetworkImage(widget.news.news_img),),
        SizedBox(height: 10),
        Text(widget.news.news_body,
          textAlign: TextAlign.justify),
        Text(widget.news.news_date,
        style: TextStyle(fontStyle: FontStyle.italic ,fontSize: 12.0),
        textAlign: TextAlign.left)

      ],
    );

  }


}