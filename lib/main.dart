import 'package:flutter/material.dart';
import 'package:potholedetection/model/user.dart';
import 'package:potholedetection/screens/onboarding_screen.dart';

import 'package:potholedetection/wrapper.dart';

import 'package:potholedetection/service/authenticate.dart';
import 'package:provider/provider.dart';

import 'ANewLogin/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Safar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
      ),
    );
  }
}
