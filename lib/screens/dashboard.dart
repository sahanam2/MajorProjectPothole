import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:jiffy/jiffy.dart';
import 'package:potholedetection/ANewLogin/login.dart';
import 'package:potholedetection/screens/alertmode.dart';
import 'package:potholedetection/screens/cameramode.dart';
import 'package:potholedetection/screens/maps.dart';
import 'package:potholedetection/screens/mypotholes.dart';
import 'package:potholedetection/screens/newtravel.dart';

Color primaryColor = Color(0xff0074ff);

class MainDashboard extends StatefulWidget {
  final String uid;
  MainDashboard(this.uid);
  @override
  _MainDashboardState createState() => _MainDashboardState(uid);
}

class _MainDashboardState extends State<MainDashboard> {
  final String uid;
  _MainDashboardState(this.uid);

  int _selectedItemIndex = 0;

  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> newlist = List();
  List<DocumentSnapshot> newlist2 = List();
  List<DocumentSnapshot> listimage = List();
  List<DocumentSnapshot> listfixed = List();
  bool isLoading = false;
  int count1 = 0;
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;
  int count5 = 0;
  int count6 = 0;
  int count7 = 0;
  List<Countbyuser> countlist = List();
  List<Countbyuser> newcount = List();
  int _currentIndex = 0;

  List<charts.Series<Countbyuser, String>> _seriesBarData;

  filterdata() {
    countlist = [];
    for (int i = 0; i < newlist.length; i++) {
      if (newlist[i].data["userid"] == uid) {
        newlist2.add(newlist[i]);
      }
    }
    for (int i = 0; i < newlist2.length; i++) {
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now().toString().split(' ')[0]) {
        count1++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 1))
              .toString()
              .split(' ')[0]) {
        count2++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toString()
                  .split(' ')[0] &&
          newlist[i].data["userid"] == uid) {
        count3++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 3))
              .toString()
              .split(' ')[0]) {
        count4++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 4))
              .toString()
              .split(' ')[0]) {
        count5++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 5))
              .toString()
              .split(' ')[0]) {
        count6++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 6))
              .toString()
              .split(' ')[0]) {
        count7++;
      }
    }
    print("count");
    print(count1);
    print(count2);
    print(count3);
    print(count4);
    print(count5);
    print(count6);
    print(count7);
    print("first");
    print(countlist);
    countlist.add(Countbyuser(uid, DateTime.now(), count1));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 1)), count2));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 2)), count3));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 3)), count4));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 4)), count5));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 5)), count6));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 6)), count7));

    countlist = countlist.reversed.toList();
    print("done");
    for (int i = 0; i < countlist.length; i++) print(countlist[i].count);
  }

  _generateData(countlist) {
    _seriesBarData = List<charts.Series<Countbyuser, String>>();
    _seriesBarData.add(
      charts.Series(
        // displayName: " ",
        domainFn: (Countbyuser potbyme, _) =>
            Jiffy(potbyme.date).MEd.split(',')[0] +
            "\n" +
            Jiffy(potbyme.date).MEd.split(',')[1],
        measureFn: (Countbyuser potbyme, _) => potbyme.count,
        fillColorFn: (_, __) =>
            charts.Color.fromHex(code: '#940068'),
        id: 'Potholes',
        data: countlist,
      ),
    );
  }

  void initState() {
    getlist();
    super.initState();
  }

  getlist() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    listtravel = querySnapshottravel.documents;

    QuerySnapshot querySnapshotimage =
        await Firestore.instance.collection("location_image").getDocuments();
    listimage = querySnapshotimage.documents;
    listtravel.addAll(listimage);
    newlist = listtravel.reversed.toList();
    QuerySnapshot querySnapshotfixed =
        await Firestore.instance.collection("fixed_potholes").getDocuments();
    listfixed = querySnapshotfixed.documents;
    setState(() {
      isLoading = true;
    });
    print(listtravel);
    filterdata();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // bottomNavigationBar: _buildBottomBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
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
      title: Text('Dashboard'),
      elevation: 0,
      actions: <Widget>[
        GestureDetector(
            onTap: () async {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())))
                  .catchError((err) => print(err));
            },
            child: Icon(Icons.exit_to_app)),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<Countbyuser> potholes) {
    countlist = potholes;
    _generateData(countlist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Potholes recorded by you',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  barGroupingType: charts.BarGroupingType.grouped,
                  // defaultRenderer: new charts.BarRendererConfig(
                  //     cornerStrategy: const charts.ConstCornerStrategy(60)),
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFDA4453),
                  Color(0xFF89216B),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            height: 200.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 35),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(listtravel.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Potholes\nrecorded",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ]),
                        Column(children: <Widget>[
                          Text(listfixed.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Potholes\nfixed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: _buildChart(context, countlist),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPotholes(list: newlist2)));
          },
          child: ListTile(
            leading: Icon(Icons.location_on, color: Colors.black),
            title: Text("MY POTHOLES",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(newlist2.length.toString() + " potholes"),
          ),
        ),
      ],
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
          color: index == _selectedItemIndex ? Colors.red : Colors.white,
        ),
        child: Icon(
          icon,
          color: index == _selectedItemIndex ? Colors.black : Colors.grey,
          size: 25.0,
        ),
      ),
    );
  }
}

class Countbyuser {
  final String uid;
  final DateTime date;
  final int count;

  Countbyuser(this.uid, this.date, this.count);
}
