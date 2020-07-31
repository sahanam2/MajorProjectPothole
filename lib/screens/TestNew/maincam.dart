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
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/dashboard.dart';

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
  TextEditingController urlcontroller = TextEditingController();
  final String uid;
  List<DocumentSnapshot> list = List();
  QuerySnapshot querySnapshot;
  _CameraModeState(this.uid);
  String finalurl;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    // else {
    //   // ignore: deprecated_member_use
    //   image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // }

    setState(() {
      _image = image;
    });
  }

  Future verify() async {
    setState(() {
      confirm = 3;
    });
    var stream = new http.ByteStream(_image.openRead());
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse(finalurl);

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
      nopotalert();
    else {
      Data data = product.resp[0];
      if (data.clas == "Pothole" && data.confidence >= 0.3) {
        setState(() {
          pothole = 1;
        });
      } else
        nopotalert();
      setState(() {
        confirm = 0;
      });
    }
  }

  void _getCurrentLocation( String surveypriority, String survey) async {
    setState(() {
      confirm = 1;
    });
    getList();
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

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
                  list[i].data["userid"] != uid ||
              list[i].data["address"] == current_address &&
                  list[i].data["userid"] != uid) {
            print(list[i].data["userid"]);
            print(uid);

            var p = (list[i].data["priority"] == null)
              ? list[i].data["NumberOfReportings"]
              : list[i].data["priority"];
            print("Priority is: " + p.toString());
            databaseReference
                .collection("location_travel")
                .document(list[i].documentID)
                .updateData({
              "NumberOfReportings": p + 1,
              "timeStamp": DateTime.now(),
            }).then((_) {
              print("update success!");
            });
            break;
          } else if (list[i].data["lat"].toString().substring(0, 7) ==
                      loc_lat.toString().substring(0, 7) &&
                  list[i].data["lon"].toString().substring(0, 7) ==
                      loc_lon.toString().substring(0, 7) &&
                  list[i].data["userid"] == uid ||
              list[i].data["address"].toString() == current_address &&
                  list[i].data["userid"] == uid) {
            print("DO NOT UPDATE");
            break;
          } else {
            check = 1;
          }
        }
      } else {
        uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address,
            place, 1, surveypriority, survey);
      }
      if (check == 1) {
        var priority = 1;

        uploadData(uid, loc_lat2, loc_lon2, time, loc_pin, current_address,
            place, priority, surveypriority, survey);
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
      Placemark place,
      var priority,
      String surveypriority,
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
      'SurveyPriority': surveypriority,
      'SurveyDescrption': survey
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
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              seturl();
            },
            child: Icon(Icons.add, color: Color(0xFF89216B)))
      ],
    );
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraMode(uid)));
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

  seturl() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: urlcontroller,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Set URL',
                        hintText: 'http://b0a52610a834.ngrok.io/detections'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CONFIRM'),
                  onPressed: () {
                    setState(() {
                      finalurl = urlcontroller.text.trim();
                    });
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('DISMISS'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(uid, "2"))); 
      },
      child: Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // nopotalert();
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
                                            side: BorderSide(
                                                color: Colors.black)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text("UPLOAD IMAGE",
                                              style: TextStyle(
                                                  color: Colors.black)),
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
          ])),
    );
  }

  void roadtype(int val) {
    setState(() {
      if (val == 1) {
        roadgroup = 1;
        p1 = true;
        survey="Main road";
      } else {
        roadgroup = 2;
        p1 = false;
        survey="Residential road";
      }
    });
  }

  void roadplace(int val) {
    setState(() {
      if (val == 1) {
        placegroup = 1;
        p2 = true;
        survey = survey +","+ "Centre of the road";
      } else {
        placegroup = 2;
        p2 = false;
        survey = survey +","+ "Edge of the road";
      }
    });
  }

  void size(int val) {
    setState(() {
      if (val == 1) {
        sizegroup = 1;
        p3 = true;
        survey = survey + ","+"Big pothole";
      } else {
        sizegroup = 2;
        p3 = false;
        survey = survey +","+ "Small pothole";
      }
    });
  }

  String surveypriority, survey;
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
              Text('What is the approximate size of the pothole?',
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
                      borderRadius: BorderRadius.circular(80.0),
                      side: BorderSide(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("DONE", style: TextStyle(color: Colors.black)),
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
                    final StorageReference firebaseStorageRef = FirebaseStorage
                        .instance
                        .ref()
                        .child('PotholeImages/$time');
                    final StorageUploadTask task =
                        firebaseStorageRef.putFile(_image);

                    // var downloadUrl =
                    //   await (await task.onComplete).ref.getDownloadURL();
                    //var url;
                    //url = downloadUrl.toString();
                    _getCurrentLocation( surveypriority, survey);
                  }),
            ],
          ),
        ),
      ),
    );
  } //  enableUpload() {

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
              Text("\n    Uploading image. \nThis might take a while",
                  textAlign: TextAlign.center)
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
                  "\nConnecting to server and verifying image. \nThis might take a while",
                  textAlign: TextAlign.center)
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
