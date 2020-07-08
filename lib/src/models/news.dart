import 'package:meta/meta.dart';

class News{
  final String documentId;
  final String news_id;
  final String news_heading;
  final String news_subheading;
  final String news_img;
  final String news_body;
  final String news_author;
  final String news_date;


  News({
    @required this.documentId,
    @required this.news_id,
    @required this.news_heading,
    @required this.news_subheading,
    @required this.news_body,
    @required this.news_img,
    @required this.news_author,
    @required this.news_date,
  });


   
}