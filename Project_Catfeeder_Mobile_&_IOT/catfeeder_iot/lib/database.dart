import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final int id;
  final double temp;
  final double humid;
  final double lux;
  final String created_at;

  WeatherData({
    required this.id,
    required this.temp,
    required this.humid,
    required this.lux,
    required this.created_at,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      id: json['id'],
      temp: json['temp'].toDouble(),
      humid: json['humid'].toDouble(),
      lux: json['lux'].toDouble(),
      created_at: json['created_at'].toString(),
    );
  }
}

Future<List<WeatherData>> fetchWeatherData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/datas'));

  if (response.statusCode == 200) {
    dynamic jsonData = json.decode(response.body);

    if (jsonData['data'] != null && jsonData['data']['data'] is List<dynamic>) {
      return (jsonData['data']['data'] as List<dynamic>)
          .map((data) => WeatherData.fromJson(data))
          .toList();
    } else {
      throw Exception(
          'Invalid data format. Expected List<dynamic>, but got $jsonData');
    }
  } else {
    throw Exception('Failed to load weather data');
  }
}
