// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient? _client;

  MqttManager() {
    _client = MqttServerClient('broker.hivemq.com', 'flutter_publisher');
    _client?.port = 1883;
    _client?.logging(on: false);
    _client?.keepAlivePeriod = 60;
    _client?.onDisconnected = _onDisconnected;
  }

  Future<void> connect() async {
    try {
      await _client?.connect();
      print('Connected to MQTT');
    } catch (e) {
      print('Error connecting to MQTT: $e');
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT');
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnect() {
    _client?.disconnect();
  }
}

class Mainpage extends StatelessWidget {
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MANUAL FEED",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 204, 153, 133),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Manual Feeder",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 182, 123, 99),
                    ),
                  ),
                  SizedBox(height: 60),
                  button(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget button(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 50),
        child: InkWell(
          onTap: () async {
            MqttManager mqttManager = MqttManager();
            await mqttManager.connect();
            mqttManager.publish('control_servo_iot_d2', '1');
            popup(context);
          },
          child: CircleAvatar(
            radius: 80,
            backgroundColor: Color.fromARGB(255, 204, 153, 133),
            child: Icon(
              Icons.power_settings_new,
              size: 80, // Sesuaikan ukuran ikon sesuai kebutuhan
              color: Colors.white,
            ),
          ),
        ),
      );

   void popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Feeding Successful"),
          content: Text("Your pet has been fed successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFF6BA35D),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
