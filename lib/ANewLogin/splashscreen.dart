import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potholedetection/ANewLogin/login.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/onboarding_screen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {
                  print(currentUser),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnboardingScreen()))
                }
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // MainDashboard(currentUser.uid)
                                      HomePage(
                                        currentUser.uid,"2"
                                      ))))
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowData())))
                      .catchError((err) => print(err))
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bgimages/wallpaperdesign.png"),
              fit: BoxFit.cover),
        ),
        child: Center(child: Text("            SAFAR\nUse Safar, don't suffer", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
        ))
      ),
    );
  }
}
