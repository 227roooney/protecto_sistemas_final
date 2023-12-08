import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceAreas {
  final String baseUrl = 'https://us-central1-uni-map-fe7c6.cloudfunctions.net/app';

  Future<Map<String, dynamic>> fetchAreaDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/areas/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load area details');
    }
  }
}
