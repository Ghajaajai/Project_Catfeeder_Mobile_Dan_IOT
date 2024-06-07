import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> dateList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlast10days.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dateList = data.map((item) => item['ts'].toString()).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HISTORY",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 50),
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 204, 153, 133),
          ),
           child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: dateList.length,
            itemExtent: 60,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Text(
                  dateList[index],
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
