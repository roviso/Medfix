import 'package:meta/meta.dart';

class Hospitals{
  final String documentId;
  final String externalId;
  final String name;
  final String description;
  final String avatarUrl;
  final String location;
  final int likeCounter;
  final String contactNo;
  final String website_url;
  final List<String> pictures;
  final List<String> services;
  final List<String> doctors;


  Hospitals({
    @required this.documentId,
    @required this.externalId,
    @required this.name,
    @required this.description,
    @required this.avatarUrl,
    @required this.location,
    @required this.likeCounter,
    @required this.pictures,
    @required this.services,
    @required this.doctors,
    @required this.contactNo,
    @required this.website_url,
  });


}