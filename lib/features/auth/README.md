# Authentication Feature

This feature handles all user authentication flows including login, registration, and password recovery.

## Screens

| Screen               | Route              | Description                    |
| -------------------- | ------------------ | ------------------------------ |
| LoginScreen          | `/login`           | User login with email/password |
| RegisterScreen       | `/register`        | New user registration          |
| ForgotPasswordScreen | `/forgot-password` | Password reset request         |

## API Endpoints

| Endpoint               | Method | Description                       |
| ---------------------- | ------ | --------------------------------- |
| `/api/login`           | POST   | Authenticate user, returns token  |
| `/api/register`        | POST   | Create new account, returns token |
| `/api/logout`          | POST   | Revoke current token              |
| `/api/user`            | GET    | Get current authenticated user    |
| `/api/forgot-password` | POST   | Request password reset email      |
| `/api/reset-password`  | POST   | Reset password with token         |

## Models

### UserModel

Represents an authenticated user.

| Field             | Type      | Description                         |
| ----------------- | --------- | ----------------------------------- |
| `id`              | int       | User ID                             |
| `name`            | String    | Full name                           |
| `email`           | String    | Email address                       |
| `emailVerifiedAt` | String?   | Verification timestamp              |
| `profilePhotoUrl` | String?   | Avatar URL                          |
| `token`           | String?   | Auth token (only on login/register) |
| `createdAt`       | DateTime? | Account creation date               |
| `updatedAt`       | DateTime? | Last update date                    |

## Controllers

### AuthController

GetX controller managing authentication state.

**Reactive State:**

- `currentUser` - Current logged-in user (nullable)
- `isLoading` - Loading state for async operations
- `isCheckingSession` - Session restoration state
- `errorMessage` - Current error message
- `successMessage` - Current success message

**Methods:**

- `login(email, password)` - Authenticate user
- `register(name, email, password, passwordConfirmation)` - Create account
- `logout()` - Sign out and clear tokens
- `forgotPassword(email)` - Request reset link
- `checkSession()` - Restore session from stored token

## Services

### AuthService

API service for authentication endpoints using Dio.

## User Flows

### Login Flow

1. User enters email and password
2. Form validates input
3. `AuthController.login()` called
4. `AuthService.login()` makes API request
5. On success: token stored in SecureStorage, navigate to dashboard
6. On error: show error message via snackbar

### Registration Flow

1. User fills name, email, password, confirm password
2. Password strength indicator updates as user types
3. Form validates all fields
4. `AuthController.register()` called
5. On success: token stored, navigate to dashboard
6. On error: show validation errors

### Forgot Password Flow

1. User enters email
2. `AuthController.forgotPassword()` called
3. On success: show "check your email" state
4. User clicks link in email to reset password

### Session Restoration

1. App starts, `AuthController.onInit()` triggers `checkSession()`
2. SecureStorage checked for existing token
3. If token exists, `AuthService.getCurrentUser()` validates it
4. If valid: user state updated, auto-navigate to dashboard
5. If invalid: token cleared, stay on login

## Security

- Tokens stored using `flutter_secure_storage`
- iOS: Keychain with first_unlock_this_device accessibility
- Android: EncryptedSharedPreferences
- Auto-logout on 401 responses via Dio interceptor
- No sensitive data logged in debug mode

## Error Handling

All API errors are caught and handled:

- Network errors → "No internet connection"
- 401 → "Invalid email or password"
- 422 → Laravel validation errors displayed
- 429 → "Too many attempts"
- Other → Generic error message

## Future Improvements

- [ ] Social login (GitHub, Google OAuth)
- [ ] Biometric authentication
- [ ] Remember me functionality
- [ ] Email verification flow
- [ ] Two-factor authentication
