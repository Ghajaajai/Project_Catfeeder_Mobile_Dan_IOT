import 'package:catfeeder_iot/daydate_page.dart';
import 'package:catfeeder_iot/historypage.dart';
import 'package:catfeeder_iot/mainpage.dart';
import 'package:catfeeder_iot/profilepage.dart';
import 'package:catfeeder_iot/schedulepage.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          Mainpage(),
          SchedulePage(),
          daydate_page(),
          HistoryPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 119,
        child: DotNavigationBar(
          backgroundColor: Color.fromARGB(255, 204, 153, 133),
          items: <DotNavigationBarItem>[
            DotNavigationBarItem(
              icon: Icon(Icons.power_settings_new_outlined, size: 17, color: Color.fromARGB(255, 99, 69, 56)),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.menu, size: 17, color: Color.fromARGB(255, 99, 69, 56)),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.home, size: 17, color: Color.fromARGB(255, 99, 69, 56)),
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.history, size: 17, color: Color.fromARGB(255, 99, 69, 56)),
            ),
             DotNavigationBarItem(
            icon: Icon(Icons.person, size: 17, color: Color.fromARGB(255, 99, 69, 56)),
          ),
          ],
          currentIndex: currentIndex,
          dotIndicatorColor: Color.fromARGB(255, 99, 69, 56),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
