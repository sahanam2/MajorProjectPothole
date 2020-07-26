// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:potholedetection/ANewLogin/login.dart';
// import 'package:potholedetection/Notifications/pushNotifications.dart';
// import 'package:potholedetection/screens/alertmode.dart';
// import 'package:potholedetection/screens/setdistance.dart';
// import 'package:potholedetection/service/authenticate.dart';
// // import 'cameramode.dart';
// import '../screens/maps.dart';
// import '../screens/newcam.dart';
// import '../screens/newtravel.dart';

// class HomePage extends StatefulWidget {
//   final String uid;
//   HomePage(this.uid);
//   @override
//   _HomePageState createState() => _HomePageState(this.uid);
// }

// class _HomePageState extends State<HomePage> {
//   final String uid;

//   final AuthService _auth = AuthService();

//   _HomePageState(this.uid);

//   @override
//   Widget build(BuildContext context) {
//     final cameraButton = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0),
//           side: BorderSide(color: Color(0XFFFCD42B)),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => CameraMode()),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF291B4F),
//         child: Text('CAMERA MODE',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     final travelButton = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: SizedBox(
//         width: 200.0,
//               child: RaisedButton(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0),
//             side: BorderSide(color: Color(0XFFFCD42B)),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => TravelMode(uid)),
//             );
//           },
//           padding: EdgeInsets.all(12),
//           color: Color(0xFF291B4F),
//           child: Text('TRAVEL MODE',
//               style: TextStyle(color: Colors.white, fontSize: 16)),
//         ),
//       ),
//     );

//     final mapsButton = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: RaisedButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(0),
//           side: BorderSide(color: Color(0XFFFCD42B)),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ViewMap()),
//           );
//         },
//         padding: EdgeInsets.all(12),
//         color: Color(0xFF291B4F),
//         child: Text('VIEW MAP',
//             style: TextStyle(color: Colors.white, fontSize: 16)),
//       ),
//     );

//     //       final ShowColData = Padding(
//     // padding: EdgeInsets.symmetric(vertical: 16.0),
//     // child: RaisedButton(
//     //   shape: RoundedRectangleBorder(
//     //     borderRadius: BorderRadius.circular(24),
//     //   ),
//     //   onPressed: () {
//     //     Navigator.push(
//     //       context,
//     //       MaterialPageRoute(builder: (context) => ShowData()),
//     //     );
//     //   },
//     //   padding: EdgeInsets.all(12),
//     //   color: Color(0xFF456796),
//     //   child: Text('Show data',
//     //       style: TextStyle(color: Colors.white, fontSize: 16)),
//     // ),
//     //       );

//     final alertme = Padding(
//       padding: EdgeInsets.symmetric(vertical: 16.0),
//       child: SizedBox(
//         width: 200.0,
//               child: RaisedButton(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0),
//             side: BorderSide(color: Color(0XFFFCD42B)),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SetDistance()),
//             );
//           },
//           padding: EdgeInsets.all(12),
//           color: Color(0xFF291B4F),
//           child: Text('ALERT MODE',
//               style: TextStyle(color: Colors.white, fontSize: 16)),
//         ),
//       ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         // title: Text("Pothole Detection System"),
//         // backgroundColor: Color(0xFF456796),
//         backgroundColor: Color(0xFF291B4F),
        
//       ),
//       endDrawer: Container(
//         width: 250.0,
//         child: Drawer(
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: ListView(padding: EdgeInsets.zero, children: <Widget>[
//                   SizedBox(
//                     height: 160.0,
//                     child: UserAccountsDrawerHeader(
//                       accountName: Text(
//                         "Shubhraaaa",
//                         style: TextStyle(
//                           fontSize: 19.0,
//                         ),
//                       ),
//                       accountEmail: Text('Star user'),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                           colors: [
//                             Color(0xFF3383CD),
//                             Color(0xFF11249F),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.notifications),
//                     title: Text('Notifications'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>FirebaseMessagingDemo()),
//                       );
//                     },
//                   ),
//                   Divider(
//                     height: 2.0,
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.account_circle),
//                     title: Text('View Profile'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ]),
//               ),
//               // elevation: 20.0,

//               Container(
//                   child: Align(
//                       alignment: FractionalOffset.bottomCenter,
//                       child: Container(
//                           child: Column(
//                         children: <Widget>[
//                           Divider(),
//                           ListTile(
//                             leading: Icon(Icons.exit_to_app),
//                             title: Text('Log out'),
//                             onTap: () async {
//                               FirebaseAuth.instance
//                                   .signOut()
//                                   .then((result) => Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => LoginPage())))
//                                   .catchError((err) => print(err));
//                             },
//                           )
//                         ],
//                       ))))
//             ],
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: DecoratedBox(
//     decoration: BoxDecoration(
//       image: DecorationImage(image: AssetImage("assets/bgimages/home.png"), fit: BoxFit.cover),
//     ),
//         child: Center(
//           child: ListView(
//             shrinkWrap: true,
//             padding: EdgeInsets.only(left: 24.0, right: 24.0),
//             children: <Widget>[
//               SizedBox(
//                 height: 150.0,
//               ),
//               SizedBox(
//                 width: 200.0,
//                 child: cameraButton
//                 ),
//               travelButton,
//               mapsButton,
//               alertme,
//               // ShowColData,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
