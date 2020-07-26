import 'package:cloud_firestore/cloud_firestore.dart';

class Loc {
  final String address;
  final String lat;
  final String lon;
  final String pincode;
  final DateTime timestamp;

  Loc({this.lat, this.lon, this.pincode, this.timestamp, this.address});
}
