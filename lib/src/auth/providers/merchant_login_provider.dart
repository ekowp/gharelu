import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth SDK.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod state management.
import 'package:byday/src/auth/data_source/auth_remote_source.dart'; // Rebranded to By Day's namespace.
import 'package:byday/src/core/state/app_state.dart'; // App state management utilities.

/// A [StateNotifier] that handles merchant login and manages the app state.
/// It communicates with the remote authentication source to log in a merchant.
class MerchantLoginProvider extends StateNotifier<AppState<User?>> {
  /// Constructor initializing the notifier with the remote data source.
  MerchantLoginProvider(this._remoteSource)
      : super(const AppState<User?>.initial());

  /// Reference to the remote data source for authentication operations.
  final AuthRemoteSource _remoteSource;

  /// Logs in a merchant user with the provided [email] and [password].
  ///
  /// This method updates the state to reflect the login process:
  /// - Sets the state to loading initially.
  /// - Calls the [merchantLogin] method on the remote source.
  /// - Updates the state to either success or error based on the response.
  Future loginAsMerchant({
    required String email,
    required String password,
  }) async {
    // Set the state to loading while login is in progress.
    state = const AppState.loading();

    // Perform the login through the remote source.
    final response =
        await _remoteSource.merchantLogin(email: email, password: password);

    // Update the state based on the login response.
    state = response.fold(
      (error) => error.when(
        serverError: (message) => AppState.error(message: message),
        noInternet: () => const AppState.noInternet(),
      ),
      (response) => AppState.success(data: response),
    );
  }
}

/// Exposes the [MerchantLoginProvider] as a Riverpod provider.
/// The provider is auto-disposed to clean up resources when not in use.
final merchantLoginProvider =
    StateNotifierProvider.autoDispose<MerchantLoginProvider, AppState<User?>>(
  (ref) => MerchantLoginProvider(ref.read(authRemoteSourceProvider)),
);
