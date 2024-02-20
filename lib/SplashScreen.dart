import 'dart:async';
import 'package:flutter/material.dart';
import 'package:koc_login_demo_proj/koc_login/KOC_Reg1.dart';
import 'LoginScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String uuid = "";

  @override
  void initState() {
    super.initState();
    initializeUUID();
  }

  Future<void> initializeUUID() async {
    uuid = await getData();
    if (uuid == "") {
      uuid = await generateUUID();
      saveData();
    }
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 2000),
          pageBuilder: (context, __, ___) => KOC_RegistrationPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  Future<String> generateUUID() async {
    var uuidGenerator = Uuid();
    return uuidGenerator.v4();
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedUUIDKey', uuid);
  }

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('savedUUIDKey') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 50.0,
            ),
            SizedBox(height: 30.0),
            Image.asset("images/koc1.png", height: 250, width: 250,),
            SizedBox(height: 30.0),
            Text(
              'KOC GATE PASS',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ],
        ),
      ),
    );
  }
}
