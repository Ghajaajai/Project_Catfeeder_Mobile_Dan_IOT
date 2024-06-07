// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NewSchedulePage extends StatefulWidget {
  NewSchedulePage({Key? key}) : super(key: key);

  @override
  _NewSchedulePageState createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  final List<String> buttonLabels = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final List<String> buttonDuration = ['3', '5', '7'];

  final TextEditingController nameController = TextEditingController();
  TimeOfDay? selectedTime = TimeOfDay.now(); // Pilih waktu awal

  List<bool> selectedDays = List.generate(7, (index) => false);
  int selectedDurationIndex = 0;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NEW SCHEDULE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'TIME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: InkWell(
                    onTap: () async => await _selectTime(context),
                    child: Container(
                      width: 60,
                      child: Text(
                        '${selectedTime?.hour}:${selectedTime?.minute}', // Tambahkan null check (?)
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'DAY(S)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(buttonLabels.length, (index) {
                return Column(
                  children: [
                    Checkbox(
                      value: selectedDays[index],
                      onChanged: (value) {
                        setState(() {
                          selectedDays[index] = value!;
                        });
                      },
                    ),
                    Text(
                      buttonLabels[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'NAME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'DURATION',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(buttonDuration.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      Checkbox(
                        value: selectedDurationIndex == index,
                        onChanged: (value) {
                          setState(() {
                            selectedDurationIndex = index;
                          });
                        },
                      ),
                      Text(
                        buttonDuration[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                minWidth: 190,
                height: 60,
                onPressed: () {
                  // Add your logic here
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "SAVE",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
