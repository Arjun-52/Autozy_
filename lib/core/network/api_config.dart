/// API Configuration for different environments
class ApiConfig {
  /// Environment types
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';

  /// Current environment (change this for different builds)
  static const String currentEnvironment = production;

  static const String apiBaseUrl = 'https://autozybackend.gyaanplant.co.in';

  /// Razorpay publishable Key ID (safe to ship in the client).
  /// Used as a fallback when the create-order response does not include a key.
  /// Currently a TEST key — replace with the live key (rzp_live_...) for production.
  static const String razorpayKeyId = 'rzp_test_SgTgIrRTm5fJjb';

  /// Base URLs for different environments
  static const Map<String, String> baseUrls = {
    development: apiBaseUrl,
    staging: 'https://staging-api.autozy.com',
    production: apiBaseUrl,
  };

  /// Get current base URL
  static String get baseUrl =>
      baseUrls[currentEnvironment] ?? baseUrls[production]!;

  /// API version
  static const String apiVersion = 'v1';

  /// API endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  static const String vehicles = '/vehicles';
  static const String bookings = '/bookings';
  static const String plans = '/plans';
  static const String inspections = '/inspections';

  /// Request configuration
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(milliseconds: 1000);

  /// Headers
  static const String contentType = 'application/json';
  static const String acceptType = 'application/json';
  static const String authScheme = 'Bearer';

  /// Feature flags (can be controlled from backend)
  static bool enableLogging = true;
  static bool enableRetry = true;
  static bool enableInterceptors = true;

  /// Rate limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerHour = 1000;
}
