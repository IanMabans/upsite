# Copilot Instructions for Upsite Flutter App

## Project Architecture

This is the **Flutter mobile app** component of a three-part API monitoring SaaS system:

1. **Flutter App (this repo)** - User-facing mobile interface
2. **Laravel Backend** - API gateway and admin dashboard
3. **Go Microservice** - Monitoring engine (performs actual checks)

**Critical: Flutter ONLY consumes the Laravel API. It does NOT:**

- Communicate with the Go service directly
- Perform monitoring checks
- Access the database
- Calculate uptime percentages
- Send alerts

See [PROJECT_OVERVIEW.md](../PROJECT_OVERVIEW.md) for the complete system architecture.

## Project Structure (Required)

Follow the feature-first structure defined in [FLUTTER_MOBILE_APP_GUIDE.md](../FLUTTER_MOBILE_APP_GUIDE.md):

```
lib/
├── main.dart              # App entry point, initializes GetX dependencies
├── app.dart               # MaterialApp with GetX routing
├── core/                  # Cross-cutting concerns
│   ├── config/
│   │   ├── env.dart      # Environment variables wrapper
│   │   └── app_config.dart
│   ├── network/
│   │   ├── dio_client.dart        # Dio singleton with interceptors
│   │   ├── api_interceptor.dart   # Auth token injection
│   │   └── api_endpoints.dart     # Centralized API paths
│   ├── storage/
│   │   └── secure_storage.dart    # flutter_secure_storage wrapper
│   └── utils/
│       ├── validators.dart        # Input validation helpers
│       └── date_formatter.dart
├── features/              # Feature modules (auth, dashboard, etc.)
│   ├── auth/
│   │   ├── controllers/
│   │   │   └── auth_controller.dart       # GetX controller
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── services/
│   │   │   └── auth_service.dart          # API calls
│   │   └── views/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── dashboard/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── services/
│   │   └── views/
│   ├── endpoints/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── services/
│   │   └── views/
│   ├── monitoring/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── services/
│   │   └── views/
│   ├── alerts/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── services/
│   │   └── views/
│   └── profile/
│       ├── controllers/
│       ├── models/
│       ├── services/
│       └── views/
├── shared/                # Shared UI components
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_widget.dart
│   │   └── empty_state.dart
│   ├── themes/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── constants/
│       ├── api_constants.dart
│       └── string_constants.dart
└── routes/                # Navigation configuration
    ├── app_pages.dart     # GetX route definitions
    └── app_routes.dart    # Route name constants
```

### Feature Module Structure

Each feature follows this pattern:

- **controllers/** - GetX controllers (business logic, state management)
- **models/** - Data models (DTOs, entities)
- **services/** - API service layer (Dio calls)
- **views/** - UI screens and widgets

Example: `features/auth/controllers/auth_controller.dart` handles login state, while `features/auth/services/auth_service.dart` makes actual API calls.

## API Communication with Dio

**All API calls go through Laravel using Dio:**

- Base URL configured via environment variables
- Development uses ngrok URLs
- Authentication: Laravel Sanctum tokens stored via `flutter_secure_storage`
- Auto-logout on 401 responses via Dio interceptor

### Dio Client Setup

```dart
// core/network/dio_client.dart
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL'),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(ApiInterceptor());
  }
}
```

### API Service Pattern

```dart
// features/auth/services/auth_service.dart
class AuthService {
  final dio = DioClient().dio;

  Future<UserModel> login(String email, String password) async {
    final response = await dio.post('/api/login', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }
}
```

## Phase 1 Implementation (Current Focus)

Implement ONLY these features (see [LARAVEL_FLUTTER_ROADMAP.md](../LARAVEL_FLUTTER_ROADMAP.md)):

### Authentication

- Login, register, logout flows
- Token persistence with `flutter_secure_storage`
- Session restoration on app launch

### Dashboard

- List monitored endpoints
- Current status (UP/DOWN)
- Last check timestamp
- Basic latency display (NO charts yet in Phase 1)

### Endpoint Management

- CRUD operations (create, read, update, delete endpoints)
- Enable/disable monitoring toggle
- Fields: name, URL, monitor type, check interval

### Monitoring Results

- Display recent results from Laravel
- Show: status, response time, timestamp
- Paginated lists (NOT computed in Flutter)

### Alerts

- List alert history (read-only)
- Display: alert type, timestamp, affected endpoint

### Profile

- View profile info
- Logout functionality
- App version display

## Development Commands

```bash
# Run app with development API URL
flutter run --dart-define=API_BASE_URL=https://your-ngrok-url.ngrok.io

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code (use before committing)
flutter format .

# Build APK (Android)
flutter build apk

# Build IPA (iOS, requires macOS)
flutter build ios
```

## Code Conventions

### Linting

- Uses `flutter_lints` package (see [analysis_options.yaml](../analysis_options.yaml))
- Run `flutter analyze` before committing
- Format all code with `flutter format .`

### Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` or `SCREAMING_SNAKE_CASE` for compile-time constants

### Widget Organization

- Prefer `const` constructors where possible
- Extract reusable widgets to `shared/widgets/`
- Keep widget files focused (one main widget per file)
- Use named parameters for widget constructors

### State Management with GetX

- **Use GetX** for all state management, routing, and dependency injection
- Controllers extend `GetxController`
- Reactive state with `.obs` variables
- Update UI with `Obx()` or `GetBuilder()`

#### GetX Controller Example

```dart
// features/auth/controllers/auth_controller.dart
class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final _secureStorage = SecureStorage();

  final isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authService.login(email, password);
      await _secureStorage.saveToken(user.token);
      currentUser.value = user;
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

#### GetX View Example

```dart
// features/auth/views/login_screen.dart
class LoginScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
      ? LoadingIndicator()
      : LoginForm());
  }
}
```

## Security Requirements

1. **Never hardcode API URLs** - use `--dart-define` or env files
2. **Store tokens securely** - use `flutter_secure_storage` only
3. **No sensitive data in logs** - especially tokens or user data
4. **Validate all user inputs** - especially URLs and endpoint configurations

## Testing Strategy

- Widget tests for UI components
- Unit tests for business logic
- Integration tests for API communication (mock responses)
- Test files mirror `lib/` structure in `test/` directory

## Common Patterns

### API Error Handling

All API calls should handle:

- Network errors (no connection)
- 401 Unauthorized (trigger logout)
- 422 Validation errors (display field errors)
- 500 Server errors (show generic error message)

### Loading States

Every async operation should show:

- Loading indicator during fetch
- Error message on failure
- Empty state when no data
- Success state with data

## Dependencies

Current dependencies (see [pubspec.yaml](../pubspec.yaml)):

- `cupertino_icons` - iOS-style icons
- `flutter_lints` - Linting rules

Phase 1 required packages:

```yaml
dependencies:
  get: ^4.6.6 # State management + routing
  dio: ^5.4.0 # HTTP client
  flutter_secure_storage: ^9.0.0 # Secure token storage
  intl: ^0.19.0 # Date formatting

dev_dependencies:
  mockito: ^5.4.4 # Mocking for tests
  build_runner: ^2.4.7 # Code generation
```

## Platform Support

- **Android**: Minimum SDK 21 (Android 5.0)
- **iOS**: Minimum iOS 12.0
- **Web**: Not supported in Phase 1
- **Desktop**: Not supported in Phase 1

## Documentation Requirements

**CRITICAL: Add documentation after EVERY implementation:**

### Code Documentation

- Add doc comments (`///`) for all public classes, methods, and properties
- Include usage examples in complex logic
- Document API response structures in service files

```dart
/// Authenticates user with email and password.
///
/// Returns [UserModel] on success.
/// Throws [DioException] on network errors.
/// Throws [UnauthorizedException] on invalid credentials.
Future<UserModel> login(String email, String password) async {
  // implementation
}
```

### Feature Documentation

Create `README.md` in each feature folder documenting:

- Feature purpose and user flows
- API endpoints used
- Models and their fields
- Known issues or limitations

Example: `features/auth/README.md`

```markdown
# Authentication Feature

## API Endpoints

- POST /api/login
- POST /api/register
- POST /api/logout

## Models

- UserModel: id, name, email, token

## Controllers

- AuthController: Handles login/register/logout state
```

## Important Best Practices

### Error Handling

- **Always** wrap API calls in try-catch blocks
- Use GetX snackbars for user-facing errors: `Get.snackbar('Error', message)`
- Log errors for debugging: `debugPrint('Error: $e')`
- Never expose raw error messages to users

### GetX Dependency Injection

```dart
// routes/app_pages.dart
GetPage(
  name: Routes.LOGIN,
  page: () => LoginScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut(() => AuthController());
  }),
)
```

### Form Validation

- Use `GetX` form validation or custom validators
- Store validators in `core/utils/validators.dart`
- Validate before API calls

```dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Invalid email format';
    return null;
  }
}
```

### API Response Models

- Create model classes with `fromJson` and `toJson` methods
- Use code generation for complex models (json_serializable)
- Store models in `features/<feature>/models/`

```dart
class EndpointModel {
  final int id;
  final String name;
  final String url;
  final bool isActive;

  EndpointModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        url = json['url'],
        isActive = json['is_active'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'is_active': isActive,
  };
}
```

### Loading & Empty States

- Show loading indicators during API calls
- Display empty states when no data exists
- Use shared widgets from `shared/widgets/`

### Navigation with GetX

```dart
// Named routes (preferred)
Get.toNamed(Routes.DASHBOARD);
Get.offAllNamed(Routes.LOGIN);  // Clear navigation stack
Get.back();  // Go back

// With arguments
Get.toNamed(Routes.ENDPOINT_DETAIL, arguments: endpointId);
// Retrieve: final id = Get.arguments as int;
```

### Constants Organization

- API endpoints: `core/network/api_endpoints.dart`
- String constants: `shared/constants/string_constants.dart`
- Colors: `shared/themes/app_colors.dart`
- Never hardcode strings or values in views

## Common Gotchas

1. **GetX Controller Lifecycle**: Controllers are disposed when not in use. Use `Get.put()` for persistent controllers or `Get.lazyPut()` with bindings.

2. **Dio Interceptors**: Add token to headers in interceptor, not in every service call.

3. **Secure Storage on iOS**: Requires keychain sharing capability enabled in Xcode.

4. **401 Handling**: Implement in Dio interceptor to auto-logout and redirect to login.

5. **Environment Variables**: Must be passed at build/run time:
   ```bash
   flutter run --dart-define=API_BASE_URL=https://api.example.com
   ```

## References

- [PROJECT_OVERVIEW.md](../PROJECT_OVERVIEW.md) - System architecture
- [FLUTTER_MOBILE_APP_GUIDE.md](../FLUTTER_MOBILE_APP_GUIDE.md) - Detailed Flutter guidelines
- [LARAVEL_FLUTTER_ROADMAP.md](../LARAVEL_FLUTTER_ROADMAP.md) - Implementation roadmap
- [GetX Documentation](https://pub.dev/packages/get) - Official GetX guide
- [Dio Documentation](https://pub.dev/packages/dio) - HTTP client reference
