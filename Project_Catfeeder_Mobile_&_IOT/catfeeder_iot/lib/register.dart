// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key});

  final TextEditingController username = TextEditingController();
  final TextEditingController pass = TextEditingController();

  Future<void> register(BuildContext context) async {
    var url = "http://192.168.18.212/flutter-login-singup/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": username.text,
      "password": pass.text,
    });

    var data = jsonDecode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
          msg: "Akun ini sudah terdaftar!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "Success") {
      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registration Successful"),
            content: Text("Berhasil Register"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // You can add any additional actions here if needed
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 157, 84, 57),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    'DAFTAR KAN AKUN ANDA',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 87, 61, 51),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 80),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () => register(context),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate back to the login page
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back to Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
