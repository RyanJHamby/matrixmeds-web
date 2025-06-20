import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrixmeds/pages/login.dart';
import 'package:matrixmeds/pages/check_interaction.dart';
import 'package:matrixmeds/pages/common_interactions.dart';
import 'package:matrixmeds/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:matrixmeds/config/config.dart';

void main() {
  runApp(const ProviderScope(child: MatrixMedsApp()));
}

class MatrixMedsApp extends ConsumerWidget {
  const MatrixMedsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      title: 'MatrixMeds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: authState.when(
        data: (user) {
          if (user == null) {
            return const LoginPage();
          }
          return const CheckInteractionPage();
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

Future<void> fetchData() async {
  try {
    final url = '${AppConfig.getBaseUrl()}/api/data';
    print('Fetching data from: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Success! Response: ${response.body}');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}
