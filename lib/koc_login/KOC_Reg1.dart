import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koc_login_demo_proj/LoginScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';


class KOC_RegistrationPage extends StatefulWidget {
  @override
  KOC_RegistrationPageState createState() => KOC_RegistrationPageState();
}

class KOC_RegistrationPageState extends State<KOC_RegistrationPage> {
  final TextEditingController civilIDController = TextEditingController();

  String uuid = "";
  String requestId = "";
  String requestType = "";
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
        "CivilID": 298010104246,
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
      var requestId = responseData['RequestID'];
      var requestType = responseData['ReqType'];

      print('ID: $requestId');
      print('REQUEST TYPE: $requestType"');

     // registerStepTwo();

     /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );*/
    } else {
      // Registration failed
      print('Registration failed');
      var responseData = json.decode(response.body);
      print(responseData);
    }
  }

  Future<void> registerStepTwo() async {
    setState(() {
      loading = true; // Show loader
    });

     final response = await http.post(
      Uri.parse(' https://apps.kockw.com/did/api/kocdigitalid/RegisterUserStep2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "RequestID": requestId,
        "CivilID": "285121208539",
        "DeviceToken": uuid,
        "ReqType": "requestType"
      }),
    );

    setState(() {
      loading = false; // Hide loader
    });

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      var responseData = json.decode(response.body);
      print("RESPONSE FROM 2 API");
      print(responseData);
      /*var requestId = responseData['RequestID'];
      var requestType = responseData['ReqType'];

      print('ID: $requestId');
      print('Token: $requestType"');*/

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
                child: loading ? CircularProgressIndicator() : Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
