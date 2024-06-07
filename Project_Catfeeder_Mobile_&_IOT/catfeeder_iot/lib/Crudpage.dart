import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<dynamic> data = [];

  TextEditingController namaController = TextEditingController();
  TextEditingController rasController = TextEditingController();
  TextEditingController umurController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse("http://192.168.18.212/flutterapi/crudpets/read.php"));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addData() async {
    final response = await http.post(
      Uri.parse("http://192.168.18.212/flutterapi/crudpets/create.php"),
      body: {
        "nama": namaController.text,
        "ras": rasController.text,
        "umur": umurController.text,
      },
    );

    if (response.statusCode == 200) {
      fetchData(); // Refresh data setelah menambahkan
      clearTextFields(); // Bersihkan input setelah menambahkan
    } else {
      throw Exception('Failed to add data');
    }
  }

  Future<void> updateData(String id) async {
    final response = await http.post(
      Uri.parse("http://192.168.18.212/flutterapi/crudpets/update.php"),
      body: {
        "id": id,
        "nama": namaController.text,
        "ras": rasController.text,
        "umur": umurController.text,
      },
    );

    if (response.statusCode == 200) {
      fetchData(); // Refresh data setelah mengupdate
      clearTextFields(); // Bersihkan input setelah mengupdate
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteData(String id) async {
    final response = await http.post(
      Uri.parse("http://192.168.18.212/flutterapi/crudpets/delete.php"),
      body: {
        "id": id,
      },
    );

    if (response.statusCode == 200) {
      fetchData(); // Refresh data setelah menghapus
      clearTextFields(); // Bersihkan input setelah menghapus
    } else {
      throw Exception('Failed to delete data');
    }
  }

  void clearTextFields() {
    namaController.clear();
    rasController.clear();
    umurController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DATA PETS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: rasController,
              decoration: InputDecoration(labelText: 'Ras',),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: umurController,
              decoration: InputDecoration(labelText: 'Umur'),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addData,
              child: Text('Tambah Data'),
            ),
            SizedBox(height: 20),
            data.isEmpty
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color.fromARGB(255, 182, 123, 99),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: ${data[index]['id']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Nama: ${data[index]['nama']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Ras: ${data[index]['ras']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Umur: ${data[index]['umur']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          updateData(data[index]['id']),
                                      icon: Icon(Icons.edit),
                                      label: Text('Update'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          deleteData(data[index]['id']),
                                      icon: Icon(Icons.delete),
                                      label: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
