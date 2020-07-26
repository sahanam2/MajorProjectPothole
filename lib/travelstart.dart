import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:potholedetection/screens/newtravel.dart';
import 'package:sensors/sensors.dart';

class TravelStart extends StatefulWidget {
  final String uid;

  const TravelStart(this.uid);
  @override
  _TravelStartState createState() => _TravelStartState(this.uid);
}

class _TravelStartState extends State<TravelStart> {
  final String uid;
  _TravelStartState(this.uid);

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF5EFB6E),
              Color(0xFF5EFB6E),
            ],
          ),
        ),
      ),
      title: Text('Detect While Travelling'),
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // bottomNavigationBar: _buildBottomBar(),
      body: //_buildBody(context),
    // child: Scaffold(
         DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bgimages/creme.png"),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    child: Text('Start') ,           
                    onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TravelMode(uid)));
                  })
                ]))));
  }
}
