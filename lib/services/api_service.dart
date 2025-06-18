import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:matrixmeds/services/auth_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    baseUrl: 'https://api.matrixmeds.com/api/v1/',
    authState: ref.watch(authStateProvider),
  );
});

class ApiService {
  final String baseUrl;
  final AsyncValue<User?> authState;

  ApiService({required this.baseUrl, required this.authState});

  Future<Map<String, dynamic>> checkInteraction({
    required String drugA,
    required String drugB,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interactions/check'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authState.value?.token}',
      },
      body: jsonEncode({
        'drug_a': drugA,
        'drug_b': drugB,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check interaction: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getCommonInteractions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/interactions/common'),
      headers: {
        'Authorization': 'Bearer ${authState.value?.token}',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch common interactions: ${response.body}');
    }
  }
}
