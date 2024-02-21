import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koc_login_demo_proj/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KOC_RegistrationPage2 extends StatefulWidget {
  @override
  KOC_RegistrationPageState2 createState() => KOC_RegistrationPageState2();
}

class KOC_RegistrationPageState2 extends State<KOC_RegistrationPage2> {
  final TextEditingController civilIDController = TextEditingController();

  String uuid = "";
  String requestId = "";
  String requestType = "";
  String authToken = "";

  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        uuid = value;
        print("your UUID is :");
        print(uuid);
      });
    });
  }

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('savedUUIDKey') ?? '';
  }

  bool loading = false;

  Future<void> registerStepOne() async {
    setState(() {
      loading = true; // Show loader
    });

    final String civilId = civilIDController.text;

    final response = await http.post(
      Uri.parse('https://apps.kockw.com/did/api/kocdigitalid/RegisterUserStep1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "CivilID": 282031702767,
        // "CivilID": 298010104246,
        // "CivilID": 285121208539,
        "DeviceToken": uuid
      }),
    );

    setState(() {
      loading = false; // Hide loader
    });

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      var responseData = json.decode(response.body);
      print(responseData);
      requestId = responseData['RequestID'];
      var requestType = responseData['ReqType'];

      print('ID: $requestId');
      print('REQUEST TYPE: $requestType"');

      // Start timer after successful registration step 1
      startTimer();
    } else {
      // Registration failed
      print('Registration failed');
      var responseData = json.decode(response.body);
      print(responseData);
    }
  }

  void startTimer() {
    // Start the timer to call registerStepTwo every 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Check if we've reached 120 iterations or authToken is received
      if (counter < 60 && authToken.isEmpty) {
        registerStepTwo();
        counter++;
      } else {
        // Stop the timer if conditions are met
        timer.cancel();
      }
    });
  }

  Future<void> registerStepTwo() async {
    setState(() {
      loading = true; // Show loader
    });

    final response = await http.post(
      Uri.parse('https://apps.kockw.com/did/api/kocdigitalid/RegisterUserStep2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "RequestID": requestId,
        "CivilID": "298010104246",
        "DeviceToken": "d9bcda6-6904-41e1-8299-488a3e298380",
        "ReqType": "Register"
      }),
    );

    setState(() {
      loading = false; // Hide loader
    });

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      var responseData2 = json.decode(response.body);
      print("RESPONSE FROM 2 API");
      print(responseData2);
      authToken = responseData2['AuthToken'];

      if (authToken.isNotEmpty) {
        // If authToken is received, stop the timer
        timer?.cancel();
        // Navigate to next screen (e.g., LoginScreen)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      // Registration failed
      print('Registration failed');
      var responseData = json.decode(response.body);
      print(responseData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Material(
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: civilIDController,
                decoration: InputDecoration(labelText: 'Civil ID'),
              ),
              SizedBox(height: 16),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: loading ? null : registerStepOne,
                child: loading ? CircularProgressIndicator() : Text('Register Step 1'),
              ),
              SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}
