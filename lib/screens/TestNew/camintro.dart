import 'package:flutter/material.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/TestNew/maincam.dart';

class CameraIntro extends StatefulWidget {
  final String uid;
  CameraIntro(this.uid);
  @override
  _CameraIntroState createState() => _CameraIntroState();
}

class _CameraIntroState extends State<CameraIntro> {
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
                child: new Text("CAPTURE IMAGE", textAlign: TextAlign.center)),
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
                    
                    Image(
                      width: 140,
                      height: 140,
                      image: AssetImage(
                        'assets/bgimages/testcam.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 28.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.yellow
                          ),
                          Expanded(child: 
                          Text(
                              "Ensure you are in a safe position before you take the picture!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold))),
                              Icon(
                            Icons.warning,
                            color: Colors.yellow
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 19.0),
                      child: Text("Using our advanced algorithm, our application classifies if the image uploaded is that of a pothole or not. Just point your camera at the pothole and click a picture!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w300)),
                    ),
                    FlatButton(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                        side: BorderSide(color: Colors.white) ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraMode(widget.uid)));
                    },
                    child: Text(
                      'CAPTURE AN IMAGE',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  ]))),
    );
  }
}
