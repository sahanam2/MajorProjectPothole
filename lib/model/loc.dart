import 'package:cloud_firestore/cloud_firestore.dart';

class DBService
{
  final String docid;
  DBService({this.docid});
  
  final CollectionReference collectionRef = Firestore.instance.collection('location_image');

  Future addData(double lat, double lon, DateTime timeStamp, String pincode, String address, String url) async
  {
    return await collectionRef.document(docid).setData({
      'lat' : lat,
      'lon' : lon,
      'timeStamp' : timeStamp,
      'pincode' : pincode,
      'address' : address,
      'url' : url,

    });
  }
}
