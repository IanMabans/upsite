# 📱 Flutter Mobile App — API Monitoring SaaS
## Copilot / Coding Agent Instructions

This Flutter project is the **primary user-facing mobile application** for an API Monitoring SaaS.

The app targets:
- Android (Play Store)
- iOS (App Store)

Web support is NOT required in Phase 1.

---

## 🎯 Core Purpose of This App

The Flutter app must:
- Authenticate users
- Allow users to manage monitored endpoints
- Display monitoring results and alerts
- Visualize uptime/latency data
- Consume ONLY the Laravel API
- NEVER talk directly to the Go microservice
- NEVER access the database

---

## 🧱 Architecture Rules (VERY IMPORTANT)

### 1️⃣ Backend Communication
- All API calls go to **Laravel**
- Base URL is configurable via environment variables
- During development, ngrok URLs will be used

Example:
```dart
const String baseUrl = String.fromEnvironment('API_BASE_URL');
2️⃣ App Structure (Required)
Use a clean, scalable structure:

vbnet
Copy code
lib/
 ├── main.dart
 ├── app.dart
 ├── core/
 │   ├── config/
 │   │   ├── env.dart
 │   │   └── app_config.dart
 │   ├── network/
 │   │   ├── api_client.dart
 │   │   └── api_interceptors.dart
 │   ├── storage/
 │   │   └── secure_storage.dart
 │   └── utils/
 ├── features/
 │   ├── auth/
 │   ├── dashboard/
 │   ├── endpoints/
 │   ├── monitoring/
 │   ├── alerts/
 │   └── profile/
 ├── shared/
 │   ├── widgets/
 │   ├── themes/
 │   └── constants/
 └── routes/
Do NOT create a monolithic structure.

🔐 Authentication (Phase 1)
Token-based authentication (Laravel Sanctum)

Store token securely using flutter_secure_storage

Auto-logout on 401 responses

Required flows:

Login

Register

Logout

Fetch current user

📊 Features to Implement (Phase 1)
✅ Authentication
Login screen

Register screen

Token persistence

Session restoration

✅ Dashboard
List monitored endpoints

Current status (UP / DOWN)

Last check timestamp

Basic latency info

NO charts yet (basic UI only).

✅ Endpoint Management
User can:

Create endpoint

Edit endpoint

Delete endpoint

Enable / disable monitoring

Fields:

Name

URL

Monitor type

Check interval

✅ Monitoring Results
Fetch recent results from Laravel

Display:

status

response time

timestamp

Paginated list

NO uptime calculations in Flutter.

✅ Alerts
List alert history

Show alert type and time

Show affected endpoint

Flutter does NOT send alerts.

✅ Profile & Settings
View profile info

Logout

App version display

Placeholder for future Remote Config flags

🚫 What Flutter MUST NOT Do
Perform API monitoring

Calculate uptime percentages

Send alerts

Talk to Go service

Run background jobs

Manage billing

Contain business logic

Store secrets insecurely

🎨 UI / UX Guidelines
Clean, minimal UI

Mobile-first

Dark mode support (optional)

Responsive layouts

Reusable widgets

No hardcoded strings (use constants)

🌍 Remote Configuration (Phase 2 – NOT NOW)
Prepare the app for:

Firebase Remote Config

Feature flags

Remote theming

Layout versioning

BUT:
❌ Do NOT integrate Firebase Remote Config yet
❌ Only prepare config abstraction

Example placeholder:

dart
Copy code
abstract class RemoteConfigService {
  bool isChristmasThemeEnabled();
}
🧪 Development & Testing
Local Development
Backend exposed via ngrok

HTTPS URLs only

Use physical device + emulator

Error Handling
Global API error handler

Graceful empty states

Retry mechanisms

📦 Dependencies (Recommended)
dio (HTTP)

flutter_secure_storage

provider / riverpod / bloc (choose one)

fl_chart (later phase)

firebase_core (later phase)

intl

🧠 Mindset for Copilot
When generating code:

Prefer clarity over cleverness

Write production-ready code

Avoid overengineering

Follow separation of concerns

Assume this app will scale to 100k+ users

✅ Definition of Done (Phase 1 Flutter)
User can login

User can add endpoints

User can see endpoint status

User can see alerts

App communicates reliably with Laravel

App works via ngrok backend

Clean architecture respected

❗ Final Reminder
This Flutter app is a client, not a brain.

All intelligence lives in:

Laravel (auth + API)

Go (monitoring + alerts)

Flutter only displays and triggers actions.

yaml
Copy code

---

## 🔥 What this MD gives you
- Copilot understands **boundaries**
- Prevents logic leaking into Flutter
- Keeps app clean and scalable
- Aligns perfectly with your Laravel + Go work