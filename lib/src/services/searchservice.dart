    
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catbox/src/models/hospital.dart';

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('hospitals')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

  Future<List<Hospitals>> searchHospitals(String searchField) async {
    return (await Firestore.instance.collection('hospitals')        
        .where('searchKey',
          isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments())
        .documents        
        .map((snapshot) => _fromDocumentSnapshot(snapshot))
        .toList();
  }

  Hospitals _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data; 

    return new Hospitals(
      documentId: snapshot.documentID,
      externalId: data['id'],
      name: data['name'],
      description: data['description'],
      avatarUrl: data['img_url'],
      location: data['location'],
      likeCounter: data['like_counter'],
      website_url: data['website_url'],
      contactNo : data['contactNo'],
      pictures: new List<String>.from(data['pictures']),
      services: new List<String>.from(data['services']),
      doctors: new List<String>.from(data['doctors']),
    );  
  }

}