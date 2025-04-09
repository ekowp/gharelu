import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth SDK.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod state management.
import 'package:byday/src/auth/data_source/auth_remote_source.dart'; // Rebranded import for By Day.
import 'package:byday/src/core/state/app_state.dart'; // App state management utilities.

/// A [StateNotifier] that manages the state of user signup.
/// Communicates with the remote authentication source to create a user account.
class UserSignupProvider extends StateNotifier<AppState<User?>> {
  /// Constructor initializing the notifier with an initial app state and the remote source.
  UserSignupProvider(this._remoteSource) : super(const AppState.initial());

  /// Reference to the remote data source for authentication operations.
  final AuthRemoteSource _remoteSource;

  /// Signs up a user with the provided details.
  ///
  /// Parameters:
  /// - [name]: User's full name.
  /// - [email]: User's email address.
  /// - [password]: User's password.
  /// - [location]: User's location (e.g., city, region).
  ///
  /// Updates the app state to reflect the signup process:
  /// - Sets the state to loading initially.
  /// - Calls the [signupUser] method on the remote source.
  /// - Updates the state to either success or error based on the response.
  Future signup({
    required String name,
    required String email,
    required String password,
    required String location,
  }) async {
    // Set the state to loading while signup is in progress.
    state = const AppState.loading();

    // Perform the signup operation via the remote source.
    final response = await _remoteSource.signupUser(
        name: name, email: email, password: password, location: location);

    // Update the state based on the signup response.
    state = response.fold(
      (error) => error.when(
        serverError: (message) => AppState.error(message: message),
        noInternet: () => const AppState.noInternet(),
      ),
      (response) => AppState.success(data: response),
    );
  }
}

/// Exposes the [UserSignupProvider] as a Riverpod provider.
/// The provider is auto-disposed to clean up resources when not in use.
final userSignupProvider =
    StateNotifierProvider.autoDispose<UserSignupProvider, AppState<User?>>(
        (ref) => UserSignupProvider(ref.read(authRemoteSourceProvider)));
