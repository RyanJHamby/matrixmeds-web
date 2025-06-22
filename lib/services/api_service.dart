import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrixmeds/services/auth_service.dart';
import 'package:matrixmeds/api/api_client.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    authState: ref.watch(authStateProvider),
  );
});

class ApiService {
  final AsyncValue<User?> authState;
  final ApiClient _apiClient = ApiClient();

  ApiService({required this.authState});

  Future<Map<String, dynamic>> checkInteraction({
    required String drugA,
    required String drugB,
  }) async {
    try {
      final response = await _apiClient.checkInteractions([drugA, drugB]);
      return {
        'interactions': response.interactions.map((i) => i.toJson()).toList(),
        'hasInteractions': response.hasInteractions,
      };
    } catch (e) {
      throw Exception('Failed to check interaction: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCommonInteractions() async {
    try {
      final response = await _apiClient.getMedications();
      return response.items.map((m) => m.toJson()).toList();
    } catch (e) {
      throw Exception('Failed to get common interactions: $e');
    }
  }
}
