import 'package:flutter/material.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/alertmode.dart';

class AlertIntro extends StatefulWidget {
  final String uid;
  AlertIntro(this.uid);
  @override
  _AlertIntroState createState() => _AlertIntroState();
}

class _AlertIntroState extends State<AlertIntro> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () { Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(widget.uid, "2"))); },
          child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF89216B),
            title: new Center(
                child: new Text("ALERT MODE", textAlign: TextAlign.center)),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height,
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
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 140,
                          height: 140,
                          image: AssetImage(
                            'assets/bgimages/testalert.png',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                              "Alert mode is a special mode made by  us to thank you for recording potholes and helping us grow our reach. Use this mode when you are travelling, and our app will give you a voice notification if there is a pothole near you.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 17.0,
                              )),
                        ),
                      ],
                    )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0),
                            side: BorderSide(color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlertMode(widget.uid)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'GET STARTED',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:40.0,
                    )
                  ]))),
    );
  }
}
