import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
QuerySnapshot querySnapshot;
@override
  void initState() {
        super.initState();
        getLocImage().then((results) {
          setState(() {
            querySnapshot = results;
          });
        });
      }


  // final databaseReference = Firestore.instance;




   getLocImage() async {
        return await Firestore.instance.collection('location_image').getDocuments();
      }

  @override
  Widget build(BuildContext context) {
    

    Widget _showList() {

        if (querySnapshot != null) {
          return ListView.builder(
            primary: false,
            itemCount: querySnapshot.documents.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, i) {
              return Column(
                children: <Widget>[

                  Text("${querySnapshot.documents[i].data['address']}"),
                  Text("${querySnapshot.documents[i].data['lat']}"),
                  Text("${querySnapshot.documents[i].data['lon']}"),
                  Text("${querySnapshot.documents[i].data['pincode']}"),
                  Text("${querySnapshot.documents[i].data['timestamp']}"),
                  Text("${querySnapshot.documents[i].data['url']}"),
                ],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }

    return Scaffold(
          body: _showList(),
        );
  }
}
