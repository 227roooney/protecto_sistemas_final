import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceRooms {
  final String baseUrl = 'https://us-central1-uni-map-fe7c6.cloudfunctions.net/app';

  Future<dynamic> fetchBuildingDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/buildings/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load building details');
    }
  }

  Future<List<dynamic>> fetchRoomsByBuilding(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/buildings/$id/rooms'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  Future<List<dynamic>> fetchAreasByBuilding(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/buildings/$id/areas'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load areas');
    }
  }
}
