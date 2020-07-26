// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:sensors/sensors.dart';

// class TravelMode extends StatefulWidget {
//   @override
//   _TravelModeState createState() => _TravelModeState();
// }

// class _TravelModeState extends State<TravelMode> {
//   int count = 0, downfirst = 0, upfirst = 0, c = 0, inc = 0;
//   var time;
//   double loc_lat3, loc_lon3;
//   int index = 0;
//   var loc_lat2, loc_lon2;
//   double x, y, z;
//   String loc_data = "";
//   String current_address = "";
//   var loc_lat, loc_lon;
//   String loc_pin;
//   final databaseReference = Firestore.instance;
//   var docId;
//   QuerySnapshot querySnapshot;

//   @override
//   void initState() {
//     super.initState();

//     getLocImage().then((results) {
//       setState(() {
//         querySnapshot = results;
//       });
//     });

//     accelerometerEvents.listen((AccelerometerEvent event) {
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

//   getLocImage() async {
//     return await Firestore.instance
//         .collection('location_travel')
//         .getDocuments();
//   }

//   Future<void> getLocation() async {
//     final position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print(position);
//     print("Hello");

//     List<Placemark> placemark = await Geolocator()
//         .placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemark[0];

//     // setState(() {
//       loc_lat = "${position.latitude}";
//       loc_lon = "${position.longitude}";
//       // double loc_lat2 = double.parse((loc_lat).toStringAsFixed(2));
//       print(loc_lat.runtimeType);
//       print(loc_lon.runtimeType);
//       loc_lat2 = loc_lat.substring(0, loc_lat.length - 1);
//       loc_lon2 = loc_lon.substring(0, loc_lon.length - 1);
//       var loc_lat3 = double.parse(loc_lat2).toStringAsFixed(3);
//         var loc_lon3 = double.parse(loc_lon2).toStringAsFixed(3);
//         // double loc_lat3 = double.parse((loc_lat2)
//         // double loc_lon3 = double.parse((loc_lon2));

//       // assert(loc_lat2 is double);
//       // print(loc_lat2);
//       // print(loc_lat2.runtimeType);

      

//       loc_pin = "${place.postalCode}";
//       loc_data = "(${position.latitude}, ${position.longitude})";
//     // });

//     if(querySnapshot!=null)
//     {
//       print("Got data");
//       print(loc_lat3);
//       print(loc_lon3);
//       print("------x------");
//     int len = querySnapshot.documents.length;
//     for (int i = 0; i < len; i++) {
//       print(len);
//       print(i);
//       print("Firebase data: ");
//       // var y = querySnapshot.documents[16].data['lat'];
//       // print(y.runtimeType);
//       print(querySnapshot.documents[i].data['lat']);
//       print(querySnapshot.documents[i].data['lon']);
//       print("----....---");

//       if (querySnapshot.documents[i].data['lat'] == 13.014
//       // print("Yeno idhuuuu");
//       && querySnapshot.documents[i].data['lon'] == 77.657) {
//         int exiscount = querySnapshot.documents[15].data['priority'];
//         int newcount = exiscount + 1;
//         var id = "Loc_" +
//             querySnapshot.documents[i].data['lat'].toString() +
//             "_" +
//             querySnapshot.documents[i].data['lon'].toString();
//           var time = new DateTime.now();
//           // uploadData(loc_lat, loc_lon, time, loc_pin, current_address, newcount);
//           print(id);
//           print("Please printttt");
//           try {
//             databaseReference
//                 .collection('location_travel')
//                 .document(id)
//                 .updateData({'lat': 2});

//             databaseReference
//                 .collection('location_travel')
//                 .document(id)
//                 .updateData({'timeStamp': time});
//           } catch (e) {
//             print(e.toString());
//           }

//         break;
//       } else {
//         index = 1;
//         print("Else condition");
//         // print(querySnapshot.documents[i].data['lat']);
//         // print(querySnapshot.documents[i].data['lon']);
//       }
//     }
//     }

//     if (index == 1) {
//       // setState(() {
//         current_address =
//             "${place.subThoroughfare}, ${place.subLocality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.locality}, ${place.country}, ${place.postalCode}";
//       // });

//       // setState(() async {
//         var time = new DateTime.now();
//         var loc_lat2 = double.parse(loc_lat);
//         var loc_lon2 = double.parse(loc_lon);
//         double loc_lat3 = double.parse((loc_lat2).toStringAsFixed(3));
//         double loc_lon3 = double.parse((loc_lon2).toStringAsFixed(3));
//         // print(loc_lat2);
//         print(loc_lat3);
//         // print(loc_lon2);
//         print(loc_lon3);

//         uploadData(loc_lat3, loc_lon3, time, loc_pin, current_address, 1);
//       // });
//     }
//   }

//   void uploadData(double lat, double lon, DateTime timeStamp, String pincode,
//       String address, int prio) async {
//     docId = "Loc_" + lat.toString() + "_" + lon.toString();
//     await databaseReference
//         .collection("location_travel")
//         .document(docId)
//         .setData({
//       'lat': lat,
//       'lon': lon,
//       'timeStamp': timeStamp,
//       'pincode': pincode,
//       'address': address,
//       'priority': prio,
//     }).then((_) {
//       print("success!");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Flutter Sensor Library"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Table(
//                 border: TableBorder.all(
//                     width: 2.0,
//                     color: Colors.blueAccent,
//                     style: BorderStyle.solid),
//                 children: [
//                   TableRow(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Y Asis : ",
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         // child: Text((y- 9.8).toStringAsFixed(2),  //trim the asis value to 2 digit after decimal point
//                         //     style: TextStyle(fontSize: 20.0)),
//                         child: Text(y.toStringAsFixed(2),
//                             style: TextStyle(fontSize: 20.0)),
//                       )
//                     ],
//                   ),
//                   TableRow(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Number of potholes: ",
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ),
//                       Text(count.toString(), style: TextStyle(fontSize: 20.0))
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }
