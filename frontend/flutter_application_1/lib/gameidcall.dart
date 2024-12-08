import 'dart:convert';

import 'package:http/http.dart' as http;


Map<String, String> userHeader = {
  "Content-type": "application/json",
  "Accept": "application/json"
};

Future<String> fetchGameId(String url) async {
  final response = await http.get(Uri.parse(url), headers: userHeader);
  if (response.statusCode == 200) {
    String gameId = response.body;
    return gameId;
  } else {
    throw Exception('Failed to load game ID');
  }
}


Future<List<double>> fetchCoordinatesId(String url) async {
  final response = await http.get(Uri.parse(url), headers: userHeader);
  if (response.statusCode == 200) {
    double latitude = json.decode(response.body)['a'];
    double longitude = json.decode(response.body)['b'];
    return [latitude, longitude];
  } else {
    throw Exception('Failed to load coordinates');
  }
}
