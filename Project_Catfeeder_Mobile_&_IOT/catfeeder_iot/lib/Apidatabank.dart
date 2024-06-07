import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiDataPage extends StatefulWidget {
  @override
  _ApiDataPageState createState() => _ApiDataPageState();
}

class _ApiDataPageState extends State<ApiDataPage> {
  List<dynamic> countries = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse("http://api.worldbank.org/v2/country?format=json"));

    if (response.statusCode == 200) {
      // API request success
      setState(() {
        countries = json.decode(response.body)[1];
      });
    } else {
      // API request failed
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "API DATA BANK DUNIA",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: countries.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                var country = countries[index];
                return ListTile(
                  title: Text('Code: ${country['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ISO2 Code: ${country['iso2Code']}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Name: ${country['name']}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
