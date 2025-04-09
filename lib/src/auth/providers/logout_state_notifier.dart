import 'package:byday/src/auth/data_source/auth_remote_source.dart'; // Updated import for byday.
import 'package:byday/src/core/state/app_state.dart'; // App state management utilities.
import 'package:hooks_riverpod/hooks_riverpod.dart'; // State management with Riverpod.

/// A [StateNotifier] that manages the state of the logout process.
/// Communicates with the remote source to handle user logout and updates the app state.
class LogoutStateNotifier extends StateNotifier<AppState<bool>> {
  /// Constructor initializing the notifier with an initial app state and the remote source.
  LogoutStateNotifier(this._remoteSource) : super(const AppState.initial());

  /// The remote data source for authentication operations.
  final AuthRemoteSource _remoteSource;

  /// Logs out the user by communicating with the remote source.
  ///
  /// Updates the app state to loading, error, or success based on the result.
  Future logout() async {
    // Set the state to loading while the logout operation is in progress.
    state = const AppState.loading();

    // Perform the logout operation through the remote source and handle the response.
    final response = await _remoteSource.logout();

    // Update the state based on the outcome of the logout operation.
    state = response.fold(
      (error) => error.when(
        serverError: (message) => AppState.error(message: message),
        noInternet: () => const AppState.noInternet(),
      ),
      (response) => AppState.success(data: response),
    );
  }
}

/// Exposes the [LogoutStateNotifier] as a Riverpod provider.
/// Marked as auto-dispose to clean up resources when the notifier is no longer in use.
final logoutStateNotifierProvider =
    StateNotifierProvider.autoDispose<LogoutStateNotifier, AppState<bool>>(
  (ref) => LogoutStateNotifier(
    ref.read(authRemoteSourceProvider),
  ),
);

