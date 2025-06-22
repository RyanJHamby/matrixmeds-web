import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrixmeds/models/medication.dart';
import 'package:matrixmeds/models/interaction.dart';
import 'package:matrixmeds/api/api_exception.dart';

class ApiClient {
  final String baseUrl;
  final String apiVersion;
  final int maxRetries;
  final Duration retryDelay;

  ApiClient({
    this.baseUrl = 'http://localhost:8000',
    this.apiVersion = 'v1',
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'User-Agent': 'MatrixMeds-Web-Client/1.0',
    };
  }

  Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      final response = await _makeRequest(
        () => http.get(
          Uri.parse('$baseUrl/health'),
          headers: this.getHeaders(),
        ),
      );
      
      return {
        'status': response.statusCode,
        'body': response.body,
        'headers': response.headers,
      };
    } catch (e) {
      throw ApiException('Health check failed: $e');
    }
  }

  Future<InteractionCheckResponse> checkInteractions(List<String> medications) async {
    try {
      final response = await _makeRequest(
        () => http.post(
          Uri.parse('$baseUrl/api/$apiVersion/interactions/check'),
          headers: this.getHeaders(),
          body: jsonEncode({'medications': medications}),
        ),
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to check interactions: ${response.statusCode}');
      }
      
      return InteractionCheckResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ApiException('Failed to check interactions: $e');
    }
  }

  Future<http.Response> _makeRequest(Future<http.Response> Function() request) async {
    int retries = 0;
    while (retries < maxRetries) {
      try {
        return await request();
      } catch (e) {
        if (retries == maxRetries - 1) {
          throw e;
        }
        await Future.delayed(retryDelay);
        retries++;
      }
    }
    throw ApiException('Request failed after $maxRetries attempts');
  }

  Future<Interaction> createInteraction(Interaction interaction) async {
    try {
      final response = await _makeRequest(
        () => http.post(
          Uri.parse('$baseUrl/api/$apiVersion/interactions'),
          headers: this.getHeaders(),
          body: jsonEncode(interaction.toJson()),
        ),
      );
      
      if (response.statusCode != 201) {
        throw ApiException('Failed to create interaction: ${response.statusCode}');
      }
      
      return Interaction.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ApiException('Failed to create interaction: $e');
    }
  }

  Future<MedicationList> getMedications() async {
    try {
      final uri = Uri.parse('$baseUrl/api/$apiVersion/medications');
      final response = await _makeRequest(
        () => http.get(uri, headers: this.getHeaders()),
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to get medications: ${response.statusCode}');
      }
      
      return MedicationList.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ApiException('Failed to get medications: $e');
    }
  }

  Future<Medication> getMedication(String medicationId) async {
    try {
      final response = await _makeRequest(
        () => http.get(
          Uri.parse('$baseUrl/api/$apiVersion/medications/$medicationId'),
          headers: this.getHeaders(),
        ),
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to get medication: ${response.statusCode}');
      }
      
      return Medication.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw ApiException('Failed to get medication: $e');
    }
  }
}
