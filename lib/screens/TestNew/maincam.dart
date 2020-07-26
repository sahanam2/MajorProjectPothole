import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Response {
  final List<Data> resp;

  Response({this.resp});

  factory Response.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['response'] as List;
    List<Data> imagesList = list.map((i) => Data.fromJson(i)).toList();

    return imagesList.length == 0
        ? Response(resp: null)
        : Response(resp: imagesList);
  }
}

class Data {
  final double confidence;
  final String clas;

  Data({this.clas, this.confidence});

  factory Data.fromJson(Map<String, dynamic> parsedJson) {
    return Data(
        clas: parsedJson['class'], confidence: parsedJson['confidence']);
  }
}
//
//@override
//_TravelModeState createState() => _TravelModeState();
//}

class CameraMode extends StatefulWidget {
  final String uid;
  const CameraMode(this.uid);
  @override
  _CameraModeState createState() => _CameraModeState(this.uid);
}

class _CameraModeState extends State<CameraMode> {
  File _image;
  int confirm = 0;
  int pothole = 0, check = 0;
  String loc_data = "";
  String current_address = "";
  String loc_lat, loc_lon, loc_pin;
  final String uid;
  List<DocumentSnapshot> list = List();
  QuerySnapshot querySnapshot;
  _CameraModeState(this.uid);

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

//verify(){
  Future verify() async {
    setState(() {
      confirm = 3;
    });
    var stream = new http.ByteStream(_image.openRead());
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse('http://b0a52610a834.ngrok.io/detections');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('images', stream, length,
        filename: "filename.jpg");

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);

    if (response.statusCode != 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title:
                  new Text("Could not connect to server.\n Please try again"),
            );
          });
      setState(() {
        _image = null;
        pothole = 0;
      });
      throw Exception('Failed to connect');
    }
    final jsonResponse = json.decode(response.body);
    Response product = new Response.fromJson(jsonResponse);

    print(product.resp);
    if (product.resp == null)
      nopot();
    else {
      Data data = product.resp[0];
      if (data.clas == "Pothole" && data.confidence >= 0.3) {
        //print("Verify fn");
        setState(() {
          pothole = 1;
        });
      } else
        nopot();
      setState(() {
        confirm = 0;
      });
    }
  }

  void _getCurrentLocation(String url, String survey) async {
    setState(() {
      confirm = 1;
    });
    getList();
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    print("Hello");

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];

    setState(() {
      loc_lat = "${position.latitude}";
      loc_lon = "${position.longitude}";
      loc_pin = "${place.postalCode}";
      loc_data = "(${position.latitude}, ${position.longitude})";
    });

    setState(() {
      current_address =
          "${place.subThoroughfare}, ${place.subLocality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.locality}, ${place.country}, ${place.postalCode}";
    });

    setState(() async {
      var time = new DateTime.now();
      var docid = "Loc_" + loc_lat + "_" + loc_lon;
      var loc_lat2 = double.parse(loc_lat);
      var loc_lon2 = double.parse(loc_lon);
      // await DBService(docid: "docid").addData(loc_lat, loc_lon, time, loc_pin, current_address, url);
      if (list.length != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i].data["lat"].toString().substring(0, 7) ==
                  loc_lat.toString().substring(0, 7) &&
              list[i].data["lon"].toString().substring(0, 7) ==
                  loc_lon.toString().substring(0, 7) &&
              list[i].data["userid"] != uid) {
            print(list[i].data["userid"]);
            print(uid);

            var p = list[i].data["priority"];
            print("Priority is: " + p.toString());
            databaseReference
                .collection("location_travel")
                .document(list[i].documentID)
                .updateData({
              "priority": p + 1,
              "timeStamp": DateTime.now(),
            }).then((_) {
              print("update success!");
            });
            break;
          } else if (list[i].data["lat"].toString().substring(0, 7) ==
                  loc_lat.toString().substring(0, 7) &&
              list[i].data["lon"].toString().substring(0, 7) ==
                  loc_lon.toString().substring(0, 7) &&
              list[i].data["userid"] == uid) {
            print("DO NOT UPDATE");
            break;
          } else {
            check = 1;
          }
        }
      } else {
        uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, url,
            place, 1, survey);
      }
      if (check == 1) {
        var priority = 1;

        uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address, url,
            place, priority, survey);
      }
      _image = null;
      pothole = 0;
    });
  }

  getList() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    list = querySnapshottravel.documents;
  }

  final databaseReference = Firestore.instance;
  var docId;
  void uploadData(
      String uid,
      double lat,
      double lon,
      DateTime timeStamp,
      String pincode,
      String address,
      String url,
      Placemark place,
      var priority,
      String survey) async {
    //getList();
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
      'source': "Camera",
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
      'NumberOfReportings': priority,
      'SurveyPriority': survey
    }).then((_) {
      // print("success!");
      setState(() {
        confirm = 0;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Thank you!"),
              content: new Text("Your complaint has been noted: \n" +
                  loc_data +
                  "\n" +
                  current_address),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF89216B),
      title: new Center(
          child: new Text("CAPTURE IMAGE", textAlign: TextAlign.center)),
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getImage(true);
          },
          tooltip: 'Capture Image',
          backgroundColor: Color(0xFF89216B),
          child: Icon(Icons.camera_alt),
        ),
        body: new Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/bgimages/wallpaperdesign.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (_image == null)
                    ? Image(
                        width: 200,
                        height: 200,
                        image: AssetImage("assets/bgimages/camtestpot.png"),
                      )
                    : pothole == 1
                        ? uploadthewholething()
                        : Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.file(_image,
                                      height: 300.0, width: 300.0),
                                  SizedBox(height: 30.0),
                                  FlatButton(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                          side:
                                              BorderSide(color: Colors.black)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text("UPLOAD IMAGE",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      onPressed: () {
                                        //SizedBox(height: 0, width: 0);
                                        verify();
                                      })
                                ]),
                          ),
                confirmFunct(),
              ],
            ),
          )
        ]));
  }
//   MaterialApp(
//       home: Scaffold(
//           body: DecoratedBox(
//     decoration: BoxDecoration(
//       image: DecorationImage(
//           image: AssetImage("assets/bgimages/1920.png"), fit: BoxFit.cover),
//     ),
//     //Center(
//     child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//                     _image == null
//                         ? Container(
//                             child: Column(
//                               children: <Widget>[
//                                 Image(
//                                     image: AssetImage(
//                                   'assets/bgimages/cartoonpothole2.jpg',
//                                 )),
//                                 //Text("Capture an image of a pothole and upload it :) "),
//                               ],
//                             ),
//                           )
//                         : pothole == 1
//                             ?
//                             uploadthewholething()
//                             : Container(
//                                 child: Column(
//                                   children: <Widget>[
//                                     Image.file(_image,
//                                         height: 300.0, width: 300.0),
//                                     RaisedButton(
//                                         child: Text("Upload"),
//                                         onPressed: () {
//                                           SizedBox(height: 0, width: 0);
//                                           verify();
// //                        setState(() {
// //                          pothole = 1;
// //                        });
//                                         }),
//                                     confirmFunct()
//                                   ],
//                                 ),
//                               ),
//           ]),
//     )));
//   }

  void roadtype(int val) {
    setState(() {
      if (val == 1) {
        roadgroup = 1;
        p1 = true;
      } else {
        roadgroup = 2;
        p1 = false;
      }
    });
  }

  void roadplace(int val) {
    setState(() {
      if (val == 1) {
        placegroup = 1;
        p2 = true;
      } else {
        placegroup = 2;
        p2 = false;
      }
    });
  }

  void size(int val) {
    setState(() {
      if (val == 1) {
        sizegroup = 1;
        p3 = true;
      } else {
        sizegroup = 2;
        p3 = false;
      }
    });
  }

  String surveypriority;
  bool p1, p2, p3;
  int roadgroup, sizegroup, placegroup;
  uploadthewholething() {
    // pothole=0;
    return SingleChildScrollView(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text('.'),
              Text(
                'On what kind of road is this pothole present?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                  value: 1,
                  groupValue: roadgroup,
                  title: const Text('Main road'),
                  onChanged: roadtype),
              RadioListTile(
                  value: 2,
                  groupValue: roadgroup,
                  title: const Text('Residential road'),
                  onChanged: roadtype),
              Text(
                'Where is this pothole located on the road?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                  value: 1,
                  groupValue: placegroup,
                  title: const Text('Centre of the road'),
                  onChanged: roadplace),
              RadioListTile(
                  value: 2,
                  groupValue: placegroup,
                  title: const Text('Edge of the road'),
                  onChanged: roadplace),
              Text(
                'What is the approximate size of the pothole?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              RadioListTile(
                  value: 1,
                  groupValue: sizegroup,
                  title: const Text('Big pothole'),
                  onChanged: size),
              RadioListTile(
                  value: 2,
                  groupValue: sizegroup,
                  title: const Text('Small pothole'),
                  onChanged: size),
              FlatButton(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80.0),
                                            side:
                                                BorderSide(color: Colors.black)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text("DONE",
                                              style:
                                                  TextStyle(color: Colors.black)),
                                        ),
                  onPressed: () async {
//                setState(() {
//                  confirm = 2;
//                });
                    if (p1)
                      surveypriority = "High";
                    else if (!p1 && !p3)
                      surveypriority = "Low";
                    else
                      surveypriority = "IMedium";
                    var time = new DateTime.now();
                    final StorageReference firebaseStorageRef =
                        FirebaseStorage.instance.ref().child('PotholeImages/$time');
                    final StorageUploadTask task =
                        firebaseStorageRef.putFile(_image);

                    //   var downloadUrl =
                    //     await (await task.onComplete).ref.getDownloadURL();
                    var url;
                    //url = downloadUrl.toString();
//print(priority);
                    _getCurrentLocation(url, surveypriority);
                  }),
            ],
          ),
        ),
      ),
    );
  } //  enableUpload() {
//    return
  //
  //       setState(() {
  //         confirm = 2;
  //       });

  //       var time = new DateTime.now();
  //       final StorageReference firebaseStorageRef =
  //           FirebaseStorage.instance.ref().child('PotholeImages/$time');
  //       final StorageUploadTask task =
  //           firebaseStorageRef.putFile(_image);

  //       var downloadUrl =
  //           await (await task.onComplete).ref.getDownloadURL();
  //       var url;
  //       url = downloadUrl.toString();

  //       _getCurrentLocation(url, priority);
  //     }),
  // Text(
  //   loc_data + "\n\n" + current_address,
  //   style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Raleway', fontSize: 12),
  // )
//        ],
//      ),
//    );
//  }

  Widget confirmFunct() {
    switch (confirm) {
      case 1:
        {
          return Center(
              child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("\nGetting your location", textAlign: TextAlign.center),
            ],
          ));
        }
        break;

      case 2:
        {
          return Center(
              child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("\n    Uploading image. \nThis might take a while", textAlign: TextAlign.center)
            ],
          ));
        }
        break;
      case 3:
        {
          return Center(
              child: Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text(
                  "\nConnecting to server and verifying image. \nThis might take a while", textAlign: TextAlign.center)
            ],
          ));
        }
        break;
      default:
        {
          return Text("");
        }
    }
  }

  nopot() {
    // return Text("Not a pothole");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Could not identify a pothole.\n Please try again"),
          );
        });
    setState(() {
      _image = null;
      pothole = 0;
    });
  }
}
