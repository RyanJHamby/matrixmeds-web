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

  AppConfig._(this.environment, this.baseUrl);

  static AppConfig get instance {
    // Set your default environment here
    // For production, you might want to read this from environment variables or build configuration
    final environment = Environment.dev;
    
    switch (environment) {
      case Environment.dev:
        return AppConfig._(Environment.dev, 'http://localhost:8000');
      case Environment.beta:
        return AppConfig._(Environment.beta, 'https://beta.matrixmeds.com');
      case Environment.gamma:
        return AppConfig._(Environment.gamma, 'https://gamma.matrixmeds.com');
      case Environment.prod:
        return AppConfig._(Environment.prod, 'https://api.matrixmeds.com');
    }
  }

  static void setEnvironment(Environment env) {
    // This is a simple implementation. In a real app, you might want to:
    // 1. Store this in secure storage
    // 2. Read from environment variables
    // 3. Use different build configurations
    AppConfig.instance = AppConfig._(env, _getBaseUrlForEnvironment(env));
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
    return AppConfig.instance.baseUrl;
  }

  static bool get isInDev => AppConfig.instance.environment == Environment.dev;
  static bool get isInBeta => AppConfig.instance.environment == Environment.beta;
  static bool get isInGamma => AppConfig.instance.environment == Environment.gamma;
  static bool get isInProd => AppConfig.instance.environment == Environment.prod;
}
