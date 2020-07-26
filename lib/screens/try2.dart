import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  // Timestamp time;
  // var a = time.toDate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "${Firestore.instance.collection('location_travel').snapshots().length.toString()}")),

      body:
          // Container(
          // child: Expander(
          //         child: Column(
          //     children: <Widget>[
          //       Text(
          //         // Firestore.instance.collection("location_travel").snapshots().length.toString()
          //         "Hello"
          //       ),

          StreamBuilder(
        stream: Firestore.instance.collection("location_travel").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data.documents[index];

                  return GestureDetector(
                    onTap: ()
                    {
                      print(documentSnapshot);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17.0, 8.0, 17.0, 17.0),
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(children: <Widget>[
                          //  Expanded(
                          //  child:
                          Text(
                            "Address: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          //  ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text(documentSnapshot["address"]),
                              SizedBox(
                                height: 5.0,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  Jiffy(documentSnapshot["timeStamp"].toDate())
                                      .yMMMdjm,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          )),
                          Icon(Icons.chevron_right)
                        ]),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(color: Colors.black),
                      ]),
                    ),
                  );
                });
          } else {
            return SizedBox(width: 0.0);
          }
        },
      ),
      //    ],
      //   ),
      // )
      // )
    );
  }
}
