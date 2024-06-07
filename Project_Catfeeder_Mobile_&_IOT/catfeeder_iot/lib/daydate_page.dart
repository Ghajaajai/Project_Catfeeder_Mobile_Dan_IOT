import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient? _client;

  MqttManager() {
    _client = MqttServerClient('broker.hivemq.com', 'flutter_subscriber');
    _client?.port = 1883;
    _client?.logging(on: false);
    _client?.keepAlivePeriod = 60;
    _client?.onDisconnected = _onDisconnected;
    _client?.onSubscribed = _onSubscribed;
  }

  Future<void> connect() async {
    try {
      await _client?.connect();
      print('Connected to MQTT');
      _subscribeToTopic('catfeeder-iot-klmpk2-datasuhulingkungan');
      _subscribeToTopic('catfeeder-iot-klmpk2-datasuhuhewan');
      _subscribeToTopic('catfeeder-iot-klmpk2-datainfrared');
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _subscribeToTopic(String topic) {
    _client?.subscribe(topic, MqttQos.atMostOnce);
  }

  void disconnect() {
    _client?.disconnect();
  }
}

class daydate_page extends StatefulWidget {
  const daydate_page({Key? key}) : super(key: key);

  @override
  _daydate_pageState createState() => _daydate_pageState();
}

class _daydate_pageState extends State<daydate_page> {
  List<Map<String, dynamic>> temperatureData = [];
  String lastFeedingTimestamp = '';
  String currentTemperature = '';
  String currentPetTemperature = '';
  String currentStockStatus = '';

  MqttManager mqttManager = MqttManager();
  List<Map<String, dynamic>> feedingData = [];

  @override
  void initState() {
    super.initState();
    fetchDataTemp();
    fetchDataFeed();
    fetchData();
    mqttManager.connect();
    _subscribeToMqttMessages();
  }

  void _subscribeToMqttMessages() {
    mqttManager._client?.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      if (c[0].topic == 'catfeeder-iot-klmpk2-datasuhulingkungan') {
        setState(() {
          currentTemperature = '$payload °C';
        });
      } else if (c[0].topic == 'catfeeder-iot-klmpk2-datasuhuhewan') {
        setState(() {
          currentPetTemperature = '$payload °C';
        });
      } else if (c[0].topic == 'catfeeder-iot-klmpk2-datainfrared') {
        setState(() {
          currentStockStatus = (payload == '1') ? 'IN STOCK' : 'OUT OF STOCK';
        });
      }
    });
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    super.dispose();
  }

  Future<void> fetchDataTemp() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getrataratasuhu.php'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          temperatureData = fetchedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchDataFeed() async {
    try {
      final response = await http.get(Uri.parse(
          'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlast5days.php'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        setState(() {
          feedingData = fetchedData;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getrataratasuhu.php'));

    if (response.statusCode == 200) {
      setState(() {
        temperatureData =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });

      await fetchLastFeedingTimestamp();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchLastFeedingTimestamp() async {
    final response = await http.get(Uri.parse(
        'https://kelompokd2iot.000webhostapp.com/petfeeder/api/getlastday.php'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> lastDayData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

      if (lastDayData.isNotEmpty) {
        setState(() {
          lastFeedingTimestamp = lastDayData[0]['ts'];
        });
      }
    } else {
      throw Exception('Failed to fetch last feeding timestamp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DASHBOARD",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 204, 153, 133),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  data(),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              children: [
                Text(
                  'TOTAL OF FEEDINGS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'LAST 5 DAYS',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(255, 204, 153, 133),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: 0,
                maxX: feedingData.length - 1.0,
                minY: -20,
                maxY: 500,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false,
                    colors: [Color.fromARGB(255, 157, 84, 57)],
                    dotData: FlDotData(show: true),
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      colors: [Color.fromARGB(255, 157, 84, 57)]
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                    ),
                    spots: List.generate(
                      feedingData.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        double.parse(feedingData[index]["jumlah data"]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var data in feedingData)
                Text(
                  '${data["jumlah data"]}x',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              children: [
                Text(
                  'AVERAGE TEMPERATURE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'LAST 5 DAYS',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(255, 204, 153, 133),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: false,
                ),
                minX: 0,
                maxX: temperatureData.length - 1.0,
                minY: 0,
                maxY: 50,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false,
                    colors: [Color.fromARGB(255, 157, 84, 57)],
                    dotData: FlDotData(show: true),
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      colors: [Color.fromARGB(255, 157, 84, 57)]
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                    ),
                    spots: List.generate(
                      temperatureData.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        double.parse(temperatureData[index]["rata_rata_suhu"]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var data in temperatureData)
                Text(
                  '${data["rata_rata_suhu"]} °C',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget data() => Column(
  mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
  children: [
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
      children: [
        Icon(
          Icons.thermostat, // Replace with the appropriate temperature icon
          color: Color.fromARGB(255, 157, 84, 57),
        ),
        SizedBox(width: 10),
        Text(
          'TEMPERATURE',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 157, 84, 57),
          ),
        ),
      ],
    ),
    Text(
      currentTemperature,
      style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.pets, // Replace with the appropriate pet icon
          color: Color.fromARGB(255, 157, 84, 57),
        ),
        SizedBox(width: 10),
        Text(
          'PET TEMPERATURE',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 157, 84, 57),
          ),
        ),
      ],
    ),
    Text(
      currentPetTemperature,
      style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_dining, // Replace with the appropriate food icon
          color: Color.fromARGB(255, 157, 84, 57),
        ),
        SizedBox(width: 10),
        Text(
          'STOCK',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 157, 84, 57),
          ),
        ),
      ],
    ),
    Text(
      currentStockStatus,
      style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time, // Replace with the appropriate clock icon
          color: Color.fromARGB(255, 157, 84, 57),
        ),
        SizedBox(width: 10),
        Text(
          'LAST FEEDING',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 157, 84, 57),
          ),
        ),
      ],
    ),
    Text(
      lastFeedingTimestamp,
      style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ],
);


}
