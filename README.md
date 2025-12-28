# 🚀 Upsite - API Monitoring Mobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.8. 1+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red)]()

A powerful Flutter mobile application for monitoring API endpoints, tracking uptime, and receiving real-time alerts about service availability. Part of a comprehensive API monitoring SaaS platform.

## 📱 Overview

Upsite is the user-facing mobile application that provides a beautiful, intuitive interface for customers to: 

- 🔍 Monitor API endpoints and services
- 📊 View real-time uptime and downtime statistics
- 📈 Visualize latency trends with interactive charts
- 🔔 Receive instant outage notifications
- ⚙️ Manage monitoring configurations and profile settings

## 🏗️ Architecture

This Flutter app is part of a three-component system:

1. **Flutter Mobile App** (This Repository) - iOS & Android user interface
2. **Laravel Backend** - API gateway, authentication, and admin dashboard
3. **Go Microservice** - Background monitoring engine

> 📖 For complete system architecture details, see [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)

## ✨ Features

### 🔐 Authentication
- Email/password registration and login
- Secure token-based authentication (Laravel Sanctum)
- Password recovery flow
- Automatic session restoration
- Secure credential storage (Keychain/EncryptedSharedPreferences)

### 📊 Monitoring Dashboard
- Real-time endpoint status display (Up/Down)
- Uptime percentage tracking
- Historical monitoring data
- Interactive latency charts
- Quick endpoint management (Add/Edit/Delete)

### 🔔 Alerts & Notifications
- Outage detection and alerts
- Push notification support (future)
- Alert history and management

### 👤 Profile Management
- User profile editing
- Account settings
- Logout functionality

## 🛠️ Tech Stack

### Core Framework
- **Flutter SDK**:  ^3.8.1
- **Dart SDK**: ^3.8.1

### Key Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `get` | ^4.6.6 | State management & routing (GetX) |
| `dio` | ^5.4.0 | HTTP client for API communication |
| `flutter_secure_storage` | ^9.2.4 | Secure token storage |
| `intl` | ^0.19.0 | Date formatting & internationalization |
| `flutter_svg` | ^2.0.10+1 | SVG asset support |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- iOS development:  Xcode 14+, CocoaPods
- Android development:  Android Studio, JDK 17+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/IanMabans/upsite.git
   cd upsite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update API base URL in your configuration files
   - Configure Laravel backend endpoint

4. **Run the app**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   ```

## 📂 Project Structure

```
lib/
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── controllers/   # GetX controllers
│   │   ├── models/        # Data models
│   │   ├── screens/       # UI screens
│   │   └── services/      # API services
│   ├── dashboard/         # Dashboard feature
│   ├── monitoring/        # Monitoring management
│   └── profile/           # User profile
├── core/
│   ├── config/           # App configuration
│   ├── theme/            # App theming
│   └── utils/            # Utilities & helpers
└── main.dart             # App entry point
```

## 🔐 Security

- **Token Storage**: Uses `flutter_secure_storage` for secure credential management
  - iOS: Keychain with `first_unlock_this_device` accessibility
  - Android: EncryptedSharedPreferences
- **Auto-logout**: Automatic session cleanup on 401 responses
- **No sensitive logging**: Debug mode excludes sensitive data

## 📱 Platform Support

| Platform | Minimum Version | Status |
|----------|----------------|--------|
| iOS | 12.0+ | ✅ Supported |
| Android | 21+ (Lollipop) | ✅ Supported |

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## 🏗️ Build for Production

### iOS
```bash
flutter build ios --release
# Open Xcode for archive and distribution
open ios/Runner.xcworkspace
```

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

## 📚 Documentation

- [Flutter Mobile App Guide](FLUTTER_MOBILE_APP_GUIDE.md) - Detailed development guide
- [Laravel + Flutter Roadmap](LARAVEL_FLUTTER_ROADMAP.md) - Development roadmap
- [Project Overview](PROJECT_OVERVIEW.md) - System architecture
- [Authentication README](lib/features/auth/README.md) - Auth feature documentation

## 🤝 Contributing

This is a private project. For team members:

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## 🐛 Known Issues

- Currently in active development
- See [Issues](https://github.com/IanMabans/upsite/issues) for known bugs and feature requests

## 🗺️ Roadmap

- [x] Authentication system
- [x] Basic dashboard
- [ ] Endpoint management UI
- [ ] Real-time monitoring display
- [ ] Latency charts (fl_chart integration)
- [ ] Push notifications
- [ ] Biometric authentication
- [ ] Social login (GitHub, Google OAuth)
- [ ] Dark mode support

## 📄 License

Private - All rights reserved

## 👥 Authors

**IanMabans** - [@IanMabans](https://github.com/IanMabans)

## 🙏 Acknowledgments

- Laravel Sanctum for authentication
- GetX for elegant state management
- Flutter community for amazing packages

---

**Note**: This app requires a running Laravel backend and Go monitoring service to function properly. See [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) for complete setup instructions.
