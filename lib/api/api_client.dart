import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://localhost:8000';
  
  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Accept',
      'Access-Control-Request-Method': 'GET',
    };
  }

  static Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      print('Making health check request to: $baseUrl/health');
      
      // Make the request with CORS headers
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: getHeaders(),
      );
      
      print('Health check response: ${response.body}');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      
      return {
        'status': response.statusCode,
        'body': response.body,
        'headers': response.headers,
      };
    } catch (e, stackTrace) {
      print('Error in health check: $e');
      print('Stack trace: $stackTrace');
      print('Error type: ${e.runtimeType}');
      
      // Try to get more details about the error
      if (e is Exception) {
        print('Exception message: ${e.toString()}');
      }
      
      rethrow;
    }
  }
}
