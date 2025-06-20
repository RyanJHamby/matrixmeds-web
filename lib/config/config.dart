import 'package:flutter/foundation.dart';

enum Environment {
  dev,
  beta,
  gamma,
  prod,
}

class AppConfig {
  final Environment environment;
  final String baseUrl;

  static AppConfig? _instance;

  AppConfig._(this.environment, this.baseUrl);

  static AppConfig get instance {
    if (_instance == null) {
      // Read from build configuration if available
      final String? envString = const String.fromEnvironment('ENVIRONMENT');
      Environment env = envString != null 
        ? Environment.values.firstWhere(
            (e) => e.toString().split('.').last == envString,
            orElse: () => Environment.dev)
        : Environment.dev;

      _instance = AppConfig._(env, _getBaseUrlForEnvironment(env));
    }
    return _instance!;
  }

  static void setEnvironment(Environment env) {
    _instance = AppConfig._(env, _getBaseUrlForEnvironment(env));
  }

  static String _getBaseUrlForEnvironment(Environment env) {
    switch (env) {
      case Environment.dev:
        return 'http://localhost:8000';
      case Environment.beta:
        return 'https://beta.matrixmeds.com';
      case Environment.gamma:
        return 'https://gamma.matrixmeds.com';
      case Environment.prod:
        return 'https://api.matrixmeds.com';
    }
  }

  static String getBaseUrl() {
    return instance.baseUrl;
  }

  static bool get isInDev => instance.environment == Environment.dev;
  static bool get isInBeta => instance.environment == Environment.beta;
  static bool get isInGamma => instance.environment == Environment.gamma;
  static bool get isInProd => instance.environment == Environment.prod;
}
