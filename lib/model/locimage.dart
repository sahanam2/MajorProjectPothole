import 'package:cloud_firestore/cloud_firestore.dart';

class LocModel {
  String address;
  String lat;
  String lon;
  String pincode;
  DateTime timestamp;

  LocModel.fromMap(Map<String, dynamic> data) {
    address = data['address'];
    lat = data['lat'];
    lon = data['lon'];
    pincode = data['pincode'];
    timestamp = data['timestamp'];
  }
}
