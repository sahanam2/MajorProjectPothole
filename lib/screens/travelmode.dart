// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:sensors/sensors.dart';

// class TravelMode extends StatefulWidget {
//   final String uid;

//   const TravelMode(this.uid);
//   @override
//   _TravelModeState createState() => _TravelModeState(this.uid);
// }

// class _TravelModeState extends State<TravelMode> {
//   final String uid;
//   List<DocumentSnapshot> list = List();
  
//   int count = 0, downfirst = 0, upfirst = 0, c = 0, inc = 0;
//   var time;
//   int index = 0;
//   double x, y, z;
//   String loc_data = "";
//   String current_address = "";
//   var loc_lat, loc_lon;
//   String loc_pin;
//   final databaseReference = Firestore.instance;
//   var docId;
//   int check=0;
//   QuerySnapshot querySnapshot;

//   _TravelModeState(this.uid);
//     StreamSubscription accel;


//   @override
//   void initState() {
//     super.initState();

//     getList();
//     accel = accelerometerEvents.listen((AccelerometerEvent event) {
//       setState(() {
//         x = event.x;
//         y = event.y;
//         z = event.z;

//         if (downfirst == 0 && y < 8 && upfirst == 0)
//           downfirst = 1;
//         else if (upfirst == 0 && y > 12 && downfirst == 0) upfirst = 1;

//         if (upfirst == 1) {
//           if (y > 9 && y < 11 && c > 3) {
//             upfirst = 0;
//             c = 0;
//           } else if (y > 11 && inc == 0) {
//             c++;
//             inc = 1;
//           } else if (y < 9 && inc == 1) {
//             c++;
//             inc = 0;
//           }
//         } else if (downfirst == 1) {
//           if (y > 9 && y < 11 && c > 2) {
//             count++;
//             getLocation();
//             downfirst = 0;
//             c = 0;
//           } else if (y > 11 && inc == 0) {
//             c++;
//             inc = 1;
//           } else if (y < 9 && inc == 1) {
//             c++;
//             inc = 0;
//           }
//         }
//       });
//     });
//   }

//   getList()
//   async {
//     QuerySnapshot querySnapshottravel =
//         await Firestore.instance.collection("location_travel").getDocuments();
//     list = querySnapshottravel.documents;
    
//   }

//   Future<void> getLocation() async {
//     final position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print(position);
//     print("Hello");

//     List<Placemark> placemark = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemark[0];

//     loc_lat = "${position.latitude}";
//     loc_lon = "${position.longitude}";
//     loc_pin = "${place.postalCode}";
//     loc_data = "(${position.latitude}, ${position.longitude})";
//     var time = new DateTime.now();
//     current_address =
//         place.name + ", " + place.subThoroughfare + ", " + place.thoroughfare + ", " + place.subLocality + ", " + place.subAdministrativeArea + ", " + place.locality + ", " + place.administrativeArea + "${place.country}, ${place.postalCode}";

//     var loc_lat2 = double.parse(loc_lat);
//     var loc_lon2 = double.parse(loc_lon);

//     if(list.length!=null)
//     {
//     for(int i=0; i<list.length; i++)
//     {
//       if(list[i].data["lat"].toString().substring(0,7) == loc_lat.toString().substring(0,7)
//       && list[i].data["lon"].toString().substring(0,7) == loc_lon.toString().substring(0,7)
//       && list[i].data["userid"] != uid)
//       {
//         print(list[i].data["userid"]);
//         print(uid);
//         var p= list[i].data["priority"];
//         print("Priority is: " + p.toString());
//         databaseReference
//         .collection("location_travel")
//         .document(list[i].documentID)
//         .updateData({
//           "priority": p+1,
//           "timeStamp": DateTime.now(),
//         }).then((_) {
//       print("update success!");
//     });
//     break;
//       }
//       else if(list[i].data["lat"].toString().substring(0,7) == loc_lat.toString().substring(0,7)
//       && list[i].data["lon"].toString().substring(0,7) == loc_lon.toString().substring(0,7)
//       && list[i].data["userid"] == uid)
//       {
//         print("DO NOT UPDATE");
//         break;
//       }
//       else
//       {
//         check =1;
        
//       }
//     }
//     }
//     else
//     {
//       uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place, 1);
//     }
//     if(check ==1)
//     {
//         var priority=1;
//         uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place, priority);
//     }

//     // uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, place, 0);
//   }

//   void uploadData(String uid,double lat, double lon, DateTime timeStamp, String pincode, String address, Placemark place, var priority) async {
//     var dateref = DateFormat("ddMMyyyy_hhmmss").format(DateTime.parse(timeStamp.toString()));
//     docId = "Loc_" + lat.toString() + "_" + lon.toString() + "_" + dateref.toString();
//     await databaseReference
//         .collection("location_travel")
//         .document(docId)
//         .setData({
//       'userid':uid,
//       'lat': lat,
//       'lon': lon,
//       'timeStamp': timeStamp,
//       'pincode': pincode,
//       'address': address,
//       'thoroughfare' : place.thoroughfare,
//       'subThoroughfare' : place.subThoroughfare,
//       'subLocality' : place.subLocality,
//       'subAdministrativeArea' : place.subAdministrativeArea,
//       'placename' : place.name,
//       'locality' : place.locality,
//       'administrativeArea' : place.administrativeArea,
//       'priority' : priority      
//     }).then((_) {
//       print("success!");
//     });
//   }




//   @override
//   Widget build(BuildContext context) {
//     // print("Shubhra".substring(0, 3));
//     return WillPopScope(
//           onWillPop: () { 
            
//             Navigator.pop(context);
//             accel.cancel();
//            },
//           child: Scaffold(
//           appBar: AppBar(
//             title: Text("Travel Mode"),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Table(
//                   border: TableBorder.all(
//                       width: 2.0,
//                       color: Colors.blueAccent,
//                       style: BorderStyle.solid),
//                   children: [
//                     TableRow(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Y Asis : ",
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           // child: Text((y- 9.8).toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
//                           //     style: TextStyle(fontSize: 20.0)),
//                           child: Text(y.toStringAsFixed(2),
//                               style: TextStyle(fontSize: 20.0)),
//                         )
//                       ],
//                     ),
//                     TableRow(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Number of potholes: ",
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                         Text(count.toString(), style: TextStyle(fontSize: 20.0))
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
