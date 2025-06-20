# MatrixMeds Web Frontend

Frontend package for the MatrixMeds application

## Environment Configuration

MatrixMeds supports multiple deployment environments. The application can be configured to run in one of the following environments:

- `dev` - Local development environment (http://localhost:8000)
- `beta` - Beta testing environment (https://beta.matrixmeds.com)
- `gamma` - Gamma testing environment (https://gamma.matrixmeds.com)
- `prod` - Production environment (https://api.matrixmeds.com)

### Setting the Environment

The environment can be set in two ways:

1. **At Runtime**:
```dart
import 'package:matrixmeds/config/config.dart';

void main() {
  AppConfig.setEnvironment(Environment.dev); // or beta, gamma, prod
  runApp(const MatrixMedsApp());
}
```

2. **Using Build Configuration**:
For production builds, it's recommended to set the environment using build configuration. This can be done by passing the environment as a build argument:

```bash
# For Flutter CLI
flutter build web --dart-define=ENVIRONMENT=prod

# For Flutter run
flutter run -d web-server --dart-define=ENVIRONMENT=prod
```

### Accessing Environment Information

You can check the current environment anywhere in your code using the following helper methods:

```dart
import 'package:matrixmeds/config/config.dart';

if (AppConfig.isInDev) {
  // Development specific code
}

if (AppConfig.isInProd) {
  // Production specific code
}

// Get the current base URL
final baseUrl = AppConfig.getBaseUrl();
```
