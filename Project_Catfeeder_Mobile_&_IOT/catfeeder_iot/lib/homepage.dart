// ignore_for_file: prefer_const_constructors, unused_import, unused_label, use_build_context_synchronously
import 'package:catfeeder_iot/register.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:catfeeder_iot/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController username = TextEditingController();
  final TextEditingController pass = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      var url = "http://192.168.18.212/flutter-login-singup/login.php";
      var response = await http.post(Uri.parse(url), body: {
        "username": username.text,
        "password": pass.text,
      });

      var data = jsonDecode(response.body);
      if (data["status"] == "Success") {
        // Simpan informasi pengguna ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username.text);

        Fluttertoast.showToast(
          msg: "Berhasil Login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationPage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Gagal Login"),
              content: Text("Username Atau Password Salah!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error: $e");
      // Handle the error, log it, or show an error message to the user
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
                    'WILEUJENG SUMPING',
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
                      onPressed: () => login(context),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
