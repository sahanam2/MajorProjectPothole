import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MyPotholes extends StatefulWidget {
  final List<DocumentSnapshot> list;

  const MyPotholes({Key key, this.list}) : super(key: key);
  @override
  _MyPotholesState createState() => _MyPotholesState(list);
}

class _MyPotholesState extends State<MyPotholes> {
  final List<DocumentSnapshot> list;
  _MyPotholesState(this.list);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFDA4453),
              Color(0xFF89216B),
            ],
          ),
        ),
      ),
      title: Text('My potholes'),
      elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: (list[i].data["url"] == null)
                                ? Icon(Icons.directions_car, color: Colors.black)
                                : Icon(Icons.camera_alt, color: Colors.black),
                            title: Text(list[i].data["address"]),
                            subtitle: Text(
                                Jiffy(list[i].data["timeStamp"].toDate()).yMMMEdjm),
                          ),
                          Divider(color: Colors.grey),
                        ],
                      );
                    }),
              ),
          ],
        ),
      )
      
    );
  }
}