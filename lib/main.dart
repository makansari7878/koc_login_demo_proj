import 'package:flutter/material.dart';
import 'package:koc_login_demo_proj/SplashScreen.dart';
import 'koc_login/KOC_Reg1.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KOC PROJECT1",
      home: SplashScreen(),
    );
  }

}
