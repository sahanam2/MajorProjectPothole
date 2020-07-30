import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:sensors/sensors.dart';

class TravelMode extends StatefulWidget {
  final String uid;

  const TravelMode(this.uid);
  @override
  _TravelModeState createState() => _TravelModeState(this.uid);
}

class _TravelModeState extends State<TravelMode> {
  final String uid;
  List<DocumentSnapshot> list = List();
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  bool isLoading = false;
  int count = 0, downfirst = 0, upfirst = 0, c = 0, inc = 0;
  var time;
  int index = 0;
  double x, y, z;
  String loc_data = "";
  String current_address = "";
  var loc_lat, loc_lon;
  String loc_pin;
  final databaseReference = Firestore.instance;
  var docId;
  int check = 0;
  int paused = 0;
  int resumed = 0;
  QuerySnapshot querySnapshot;

  _TravelModeState(this.uid);
  StreamSubscription accel;

  @override
  void initState() {
    paused = 0;
    super.initState();

    getList();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      //   accel= accelerometerEvents.listen((AccelerometerEvent event){

      if (mounted)
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;

          if (downfirst == 0 && y < 6 && upfirst == 0)
            downfirst = 1;
          else if (upfirst == 0 && y > 12 && downfirst == 0) upfirst = 1;

          if (upfirst == 1) {
            if (y > 9 && y < 11 && c > 3) {
              upfirst = 0;
              c = 0;
            } else if (y > 11 && inc == 0) {
              c++;
              inc = 1;
            } else if (y < 9 && inc == 1) {
              c++;
              inc = 0;
            }
          } else if (downfirst == 1) {
            if (y > 9 && y < 11 && c > 2) {
              //count++;
              getLocation();
              downfirst = 0;
              c = 0;
            } else if (y > 11 && inc == 0) {
              c++;
              inc = 1;
            } else if (y < 9 && inc == 1) {
              c++;
              inc = 0;
            }
          }
        });
    }));
  }

  getList() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    list = querySnapshottravel.documents;
    if (list != null) {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> getLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    print("Hello");

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];

    loc_lat = "${position.latitude}";
    loc_lon = "${position.longitude}";
    loc_pin = "${place.postalCode}";
    loc_data = "(${position.latitude}, ${position.longitude})";
    var time = new DateTime.now();
    current_address = place.name +
        ", " +
        place.subThoroughfare +
        ", " +
        place.thoroughfare +
        ", " +
        place.subLocality +
        ", " +
        place.subAdministrativeArea +
        ", " +
        place.locality +
        ", " +
        place.administrativeArea +
        "${place.country}, ${place.postalCode}";

    var loc_lat2 = double.parse(loc_lat);
    var loc_lon2 = double.parse(loc_lon);

    if (list.length != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].data["lat"].toString().substring(0, 6) ==
                    loc_lat.toString().substring(0, 6) &&
                list[i].data["lon"].toString().substring(0, 6) ==
                    loc_lon.toString().substring(0, 6) &&
                list[i].data["userid"] != uid ||
            list[i].data["address"] == current_address &&
                list[i].data["userid"] != uid) {
          print(list[i].data["userid"]);
          print(uid);
          if (mounted)
            setState(() {
              count++;
            });
          var p = list[i].data["NumberOfReportings"];
          print("Priority is: " + p.toString());
          databaseReference
              .collection("location_travel")
              .document(list[i].documentID)
              .updateData({
            "NumberOfReportings": p + 1,
            "timeStamp": DateTime.now(),
            "userid": uid,
          }).then((_) {
            print("update success!");
          });
          break;
        } else if (list[i].data["lat"].toString().substring(0, 6) ==
                    loc_lat.toString().substring(0, 6) &&
                list[i].data["lon"].toString().substring(0, 6) ==
                    loc_lon.toString().substring(0, 6) &&
                list[i].data["userid"] == uid ||
            list[i].data["address"].toString() == current_address &&
                list[i].data["userid"] == uid) {
          print("DO NOT UPDATE");
          //ToDo: Remove the following setstate fn
//          setState(() {
//            count++;
//          });
          break;
        } else {
          check = 1;
        }
      }
    } else {
      if (mounted)
        setState(() {
          count++;
        });
      uploadData(
          uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place, 1);
    }
    if (check == 1) {
      var priority = 1;
      if (mounted)
        setState(() {
          count++;
        });
      uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place,
          priority);
    }

    // uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place, 0);
  }

  void uploadData(String uid, double lat, double lon, DateTime timeStamp,
      String pincode, String address, Placemark place, var priority) async {
    var dateref = DateFormat("ddMMyyyy_hhmmss")
        .format(DateTime.parse(timeStamp.toString()));
    docId = "Loc_" +
        lat.toString() +
        "_" +
        lon.toString() +
        "_" +
        dateref.toString();
    await databaseReference
        .collection("location_travel")
        .document(docId)
        .setData({
      'userid': uid,
      'source': "Sensor",
      'lat': lat,
      'lon': lon,
      'timeStamp': timeStamp,
      'pincode': pincode,
      'address': address,
      'thoroughfare': place.thoroughfare,
      'subThoroughfare': place.subThoroughfare,
      'subLocality': place.subLocality,
      'subAdministrativeArea': place.subAdministrativeArea,
      'placename': place.name,
      'locality': place.locality,
      'administrativeArea': place.administrativeArea,
      'NumberOfReportings': priority
    }).then((_) {
      print("success!");
    });
  }

//   @override
//   void dispose() {
//     super.dispose();
//     //if(!mounted) return;
//     for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
//       subscription?.cancel();
// //accel.cancel();

//     }
//   }

  void pause([Future resume]) {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.pause();
    }
  }

  void resume() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Shubhra".substring(0, 3));
    return WillPopScope(
        onWillPop: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage(this.uid, "2")));
          accel.cancel();
        },
        child: Scaffold(
          // appBar: PreferredSize(
          // preferredSize: Size.fromHeight(10.0),
          // child: AppBar(
          //   // title: Text("Travel Mode"),
          // )
          // ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bgimages/wallpaperdesign.png"),
                  fit: BoxFit.cover),
            ),
            child: (!isLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "$count",
                              style: TextStyle(fontSize: 180.0),
                            ),
                            (paused == 0)
                                ? Text(
                                    "NEW POTHOLES DETECTED ",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text("PAUSED",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 20.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.pause_circle_outline),
                                    iconSize: 60.0,
                                    color: (paused != 0)
                                        ? Colors.grey
                                        : Colors.black,
                                    onPressed: (paused != 0)
                                        ? null
                                        : () {
                                            pause();
                                            setState(() {
                                              paused = 1;
                                            });
                                          },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.play_circle_outline),
                                    iconSize: 60.0,
                                    color: (paused != 1)
                                        ? Colors.grey
                                        : Colors.black,
                                    onPressed: (paused != 1)
                                        ? null
                                        : () {
                                            setState(() {
                                              paused = 0;
                                            });
                                            resume();
                                          },
                                  )
                                ]),
                          ],
                        )),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: FlatButton(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                  side: BorderSide(color: Colors.black)),
                              child: Text('STOP RECORDING',
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.white)),
                              // icon: Icon(Icons.stop),
                              onPressed: () {
                                // nopotalert();
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       // return object of type Dialog
                                //       return AlertDialog(
                                //         title: new Text("Thank you!"),
                                //         content: new Text(
                                //             "You recorded $count potholes! \n"),
                                //         actions: <Widget>[
                                //           // usually buttons at the bottom of the dialog
                                //           new FlatButton(
                                //             child: new Text("Close"),
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         ],
                                //       );
                                //     });
                                //});
                                // dispose();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(uid, "2")));
                                print("Stop");
                              },
                            )),
                        SizedBox(height: 60.0)
                      ],
                    ),
                    //   ],
                    // ),
                  ),
          ),
        ));
  }

  void nopotalert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Oops!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
                  child: Text(
                      "We could not identify a pothole in this picture.",
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CameraMode(uid)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 17.0, bottom: 17.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF89216B),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "Try again",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
