// ignore_for_file: prefer_const_constructors

import 'package:catfeeder_iot/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   
   

  String username = "";

  @override
  void initState() {
    super.initState();
    // Ambil informasi pengguna dari SharedPreferences
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 182, 123, 99),
              Color.fromARGB(255, 157, 84, 57),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(height: 50),
              buildProfileImage(
                70,
                'https://images.pexels.com/photos/3826501/pexels-photo-3826501.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
              ),
              SizedBox(height: 20),
              buildTextField("USERNAME", username),
              SizedBox(height: 150),
              buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage(double sizeRadius, String linkImage) => Center(
        child: CircleAvatar(
          radius: sizeRadius,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.network(
              linkImage,
              fit: BoxFit.cover,
              width: sizeRadius * 2,
              height: sizeRadius * 2,
            ),
          ),
        ),
      );

  Widget buildTextField(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 157, 84, 57),
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildLogoutButton(BuildContext context) => Center(
        child: GestureDetector(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('username');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 182, 123, 99),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  key: UniqueKey(),
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      );
}
