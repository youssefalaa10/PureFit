# Token Validation and Refresh System

This system handles automatic token validation and refresh for the PureFit app to ensure users stay authenticated when their tokens expire after 30 days.

## Components

### 1. TokenValidationService
- **Location**: `lib/Core/Services/token_validation_service.dart`
- **Purpose**: Validates if the current token is still valid and not expired
- **Key Methods**:
  - `isTokenValid()`: Checks if token exists and is not expired
  - `isTokenNearExpiry()`: Checks if token expires within 7 days
  - `calculateTokenExpiry()`: Calculates 30-day expiration date

### 2. SaveTokenDB (Updated)
- **Location**: `lib/Core/local_db/DioSavedToken/save_token.dart`
- **Purpose**: Stores and retrieves token data including expiration timestamp
- **Key Changes**:
  - Now stores token with expiration timestamp
  - Added `getTokenData()` method to retrieve full token information
  - Uses JSON serialization for token data

### 3. TokenRefreshService
- **Location**: `lib/Core/Services/token_refresh_service.dart`
- **Purpose**: Handles token refresh when 401 errors occur
- **Key Methods**:
  - `refreshToken()`: Attempts to refresh the token via API
  - `handleTokenRefresh()`: Handles refresh and logout if refresh fails

### 4. DioInterceptor (Updated)
- **Location**: `lib/Core/Networking/interceptors/dio_interceptor.dart`
- **Purpose**: Intercepts 401 responses and attempts token refresh
- **Key Features**:
  - Automatically retries failed requests after token refresh
  - Prevents multiple simultaneous refresh attempts
  - Handles logout if refresh fails

### 5. AuthService
- **Location**: `lib/Core/Services/auth_service.dart`
- **Purpose**: Centralized authentication management
- **Key Methods**:
  - `logout()`: Clears token and navigates to login
  - `isAuthenticated()`: Checks if user is authenticated

### 6. TokencheckCubit (Updated)
- **Location**: `lib/Features/AuthHelper/cubit/tokencheck_cubit.dart`
- **Purpose**: Validates token on app startup
- **Key Changes**:
  - Now uses TokenValidationService for proper expiration checking
  - Clears expired tokens automatically

## How It Works

1. **App Startup**: TokencheckCubit validates the stored token using TokenValidationService
2. **API Requests**: DioInterceptor adds the token to all outgoing requests
3. **401 Response**: When a 401 is received, DioInterceptor attempts token refresh
4. **Token Refresh**: TokenRefreshService calls the backend refresh endpoint
5. **Success**: If refresh succeeds, the original request is retried with the new token
6. **Failure**: If refresh fails, user is automatically logged out and redirected to login

## Backend Requirements

**⚠️ Currently Not Available**: The backend refresh endpoint is not yet implemented. The system is configured to handle this gracefully by logging out users when tokens expire.

When the backend is ready, implement a token refresh endpoint:
- **URL**: `/auth/refresh`
- **Method**: POST
- **Headers**: `Authorization: Bearer <current_token>`
- **Response**: `{"token": "new_jwt_token"}`

To enable token refresh, uncomment the code in `TokenRefreshService.refreshToken()` method.

## Configuration

- **Token Validity**: 30 days (configurable in TokenValidationService)
- **Near Expiry Warning**: 7 days before expiration
- **Refresh Endpoint**: Set in ApiConstants.apiRefreshToken (ready for future use)
- **Current Behavior**: Users are logged out when token expires (no refresh available)

## Usage

The system works automatically once implemented. No additional code is needed in your UI components - the token validation and refresh happens transparently in the background.
