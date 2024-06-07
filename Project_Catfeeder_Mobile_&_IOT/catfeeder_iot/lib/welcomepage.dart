import 'package:catfeeder_iot/homepage.dart';
import 'package:flutter/material.dart';

class Welcomepage extends StatelessWidget {
  Welcomepage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 157, 84, 57),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome To OnlyFeed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Handle button click here
                  print("Button Clicked!");
                  // Navigate to Welcomepage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    color: Colors.transparent, // Initial color
                  ),
                  child: Center(
                    child: Text(
                      "Click Me!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40), // Adjust the spacing as needed
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 310, // Adjust the width as needed for the border
                    height: 260, // Adjust the height as needed for the border
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Container(
                    width: 300, // Adjust the width as needed for the image
                    height: 250, // Adjust the height as needed for the image
                    child: Image.network(
                      'https://images.pexels.com/photos/1697100/pexels-photo-1697100.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                ],
              ),
              SizedBox(height: 180), // Adjust the spacing as needed
              Text(
                "Internet of Things",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
