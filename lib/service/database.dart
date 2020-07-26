import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potholedetection/model/locsensor.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference locCollection = Firestore.instance.collection('location_image');

  // loc list from snapshot
  List<Loc> _locListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Loc(
        address: doc.data['address'] ?? '',
        lat: doc.data['lat'] ?? '',
        lon: doc.data['lon'] ?? '',
        pincode: doc.data['pincode'] ?? '',
        timestamp: doc.data['timestamp'] ?? '',
      );
    }).toList();
  }

  // get loc stream
  Stream<List<Loc>> get brews {
    return locCollection.snapshots()
      .map(_locListFromSnapshot);
  }

}