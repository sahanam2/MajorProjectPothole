import 'package:flutter/material.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/newtravel.dart';


class TravelIntro extends StatefulWidget {
  final String uid;
  TravelIntro(this.uid);
  @override
  _TravelIntroState createState() => _TravelIntroState();
}

class _TravelIntroState extends State<TravelIntro> {
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
                child: new Text("TRAVEL MODE", textAlign: TextAlign.center)),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                        "Using sensors embedd in your smartphone, our app detects potholes based on vibrations during your journey.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 160.0,
                    height: 130.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/bgimages/mobholder.jpg',
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("To ensure potholes are recorded accurately: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27.0, vertical: 9.0),
                    child: UnorderedList([
                      "Place your phone at a stationary position as shown above.",
                      "Do not remove your phone from it's position until you have reached your destination.",
                    ]),
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
                              builder: (context) => TravelMode(widget.uid)));
                    },
                    child: Text(
                      'START',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ))),
    );
  }
}

class UnorderedList extends StatelessWidget {
  UnorderedList(this.texts);
  final List<String> texts;
  // final String icon;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      widgetList.add(UnorderedListItem(text));
      widgetList.add(SizedBox(height: 6.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Icon(Icons.brightness_1, size: 4.0, color: Colors.white),
        Text("\u2022  ", style: TextStyle(fontSize: 40.0, color: Colors.white)),
        // (icon == "check")
        //     ? Icon(Icons.check)
        //     : Text(
        //         "!",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        // Icon(Icons.arrow_right),
        SizedBox(width: 9.0),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
