import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'd7ab134ffbacb4054f247cdbe9bed3f1';

  Future<Map<String, dynamic>> fetchWeather(String? city) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      throw Exception('Failed to load weather data');
    }
  }
}
