import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koc_login_demo_proj/LoginScreen.dart';

class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true; // Show loader
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('https://reqres.in/api/register'),
      /* headers: <String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
     },*/
      body: {
        'email': "eve.holt@reqres.in",
        'password': "pistol",
      },
    );


    setState(() {
      loading = false; // Hide loader
    });

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      var responseData = json.decode(response.body);
      print(responseData);
      var id = responseData['id'];
      var token = responseData['token'];

      print('ID: $id');
      print('Token: $token');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Registration failed
      print('Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: loading ? CircularProgressIndicator() : Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
