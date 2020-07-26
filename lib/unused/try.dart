// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Baby Names',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() {
//     return _MyHomePageState();
//   }
// }

// class Loc {
//   final String address;
//   final String lat;
//   final String lon;
//   final String pincode;
//   final DateTime timestamp;
//   final DocumentReference reference;

//   Loc.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['address'] != null),
//         assert(map['lat'] != null),
//         assert(map['lon'] != null),
//         assert(map['pincode'] != null),
//         assert(map['timestamp'] != null),
//         address = map['address'],
//         lat = map['lat'],
//         lon = map['lon'],
//         pincode = map['pincode'],
//         timestamp = map['timestamp'];

//   Loc.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);

//   @override
//   String toString() => "Loc<$address:$lat:$lon:$pincode:$timestamp>";
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Baby Name Votes')),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('baby').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return LinearProgressIndicator();

//         return DataTable(
//           columns: [
//             DataColumn(label: Text('Name')),
//             DataColumn(label: Text('Votes')),
//             DataColumn(label: Text('Rapper\nname')),
//           ],
//           rows: _buildList(context, snapshot.data.documents)
//         );
//       },
//     );
//   }




//     Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//         return  snapshot.map((data) => _buildListItem(context, data)).toList();
//     }



//  List<Widget> _buildListItem(BuildContext context, DocumentSnapshot data) {
//     final record = Record.fromSnapshot(data);

//     return DataRow(cells: [
//               DataCell(Text(record.name)),
//               DataCell(Text(record.votes.toString())),
//               DataCell(Text(record.rName)),
//             ]);
//   }