import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}
class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String url = 'https://reqres.in/api/login';
    final Map<String, String> data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(Uri.parse(url), body: data);

      if (response.statusCode == 200) {
        // Login successful
        var responseData = json.decode(response.body);
        String token = responseData['token'];
        print('Login successful. Token: $token');
        // Navigate to next screen or perform other actions
      } else {
        // Login failed
        print('Login failed');
        print(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 60.0),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  RegistrationPage()
              ));
            },
                child: Text("SIGN UP", style:
                TextStyle(fontSize: 20, color: Colors.redAccent),))
          ],
        ),
      ),
    );
  }
}

