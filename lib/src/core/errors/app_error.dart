import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// `AppError` class models different error states in the application.
/// It provides structured types of errors and ensures easy handling via the `freezed` package.
@freezed
class AppError with _$AppError {
  /// Represents a server-related error.
  /// Contains a mandatory error message to describe the issue.
  const factory AppError.serverError({required String message}) = _ServerError;

  /// Represents an error for no internet connection.
  const factory AppError.noInternet() = _NoInternet;

  /// Provides a user-friendly description for the error.
  String get description {
    return when(
      serverError: (message) => 'Server Error: $message', // Formats server error message.
      noInternet: () => 'No internet connection available.', // Default description for no internet error.
    );
  }

  /// Logs the error (can be integrated with external logging services like Firebase Crashlytics).
  void logError() {
    final errorDetails = description;
    // Example: Use an external logging system to track errors.
    print('Logging error: $errorDetails'); // Replace with actual logging service.
  }
}

