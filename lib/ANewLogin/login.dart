import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potholedetection/ANewLogin/register.dart';
import 'package:potholedetection/screens/New/home.dart';
import 'package:potholedetection/screens/dashboard.dart';
import 'package:potholedetection/unused/home.dart';
import 'package:potholedetection/screens/try2.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          appBar: AppBar(
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
            // title: Text('Dashboard'),
            // backgroundColor: Color(0xFF31427d),
            title: Text("Login"),
          ),
          body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email*', hintText: "john.doe@gmail.com"),
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password*', hintText: "********"),
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      height: 40.0,
                      width: 100.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_loginFormKey.currentState.validate()) {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                    .collection("users")
                                    .document(currentUser.user.uid)
                                    .get()
                                    .then((DocumentSnapshot result) =>
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                      currentUser.user.uid,
                                                    ))))
                                    .catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xff89216B), Color(0xffDA4453)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text("Don't have an account yet?"),
                    FlatButton(
                      child: Text("Register here!"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                    )
                  ],
                ),
              )))),
    );
  }
}
