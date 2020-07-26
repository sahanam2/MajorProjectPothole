import 'package:flutter/material.dart';

import 'alertmode.dart';

class SetDistance extends StatefulWidget {
  @override
  _SetDistanceState createState() => _SetDistanceState();
}

class _SetDistanceState extends State<SetDistance> {
  TextEditingController distcontroller = new TextEditingController();
  var dist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("SET DISTANCE"),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              controller: distcontroller,
              keyboardType: TextInputType.number,
              decoration:
              
                  InputDecoration(labelText: 'Alerting distance', hintText: "Alerting distance"),
              
            ),
          ),
          RaisedButton(
            child: Text("Next"),
            onPressed: () {
              setState(() {
                dist = distcontroller.text;
                print(dist);
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => AlertMode(dist)));
            }
          )
        ],
      ),
    );
  }
}
