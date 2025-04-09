import 'package:byday/src/auth/data_source/auth_remote_source.dart'; // Updated import for byday.
import 'package:byday/src/core/state/app_state.dart'; // App state management utilities.
import 'package:hooks_riverpod/hooks_riverpod.dart'; // State management with Riverpod.

/// A [StateNotifier] that manages the state of the user deletion process.
/// Communicates with the remote source to handle user deletion and updates the app state accordingly.
class DeleteUserProviderNotifier extends StateNotifier<AppState<bool>> {
  /// Constructor initializing the notifier with an initial app state and the remote source.
  DeleteUserProviderNotifier(this._remoteSource)
      : super(const AppState.initial());

  /// The remote data source for authentication operations.
  final AuthRemoteSource _remoteSource;

  /// Deletes a user by communicating with the remote source.
  ///
  /// Parameters:
  /// - [message]: An optional message associated with the user deletion.
  /// - [password]: The user's password for re-authentication during deletion.
  /// - [isMerchant]: A flag indicating if the user is a merchant.
  ///
  /// Updates the app state to loading, error, or success based on the outcome of the operation.
  Future deleteUser({
    String? message,
    required String password,
    bool isMerchant = false,
  }) async {
    // Set the state to loading while the operation is being performed.
    state = const AppState.loading();

    // Perform the deletion through the remote source and handle the response.
    final response = await _remoteSource.deleteUser(
        message: message, password: password, isMerchant: isMerchant);

    // Update the state based on the result of the operation.
    state = response.fold(
        (error) => error.when(
              serverError: (message) => AppState.error(message: message),
              noInternet: () => const AppState.noInternet(),
            ),
        (response) => AppState.success(data: response));
  }
}

/// Exposes the [DeleteUserProviderNotifier] as a Riverpod provider.
/// Marked as auto-dispose to clean up resources when the notifier is no longer in use.
final deleteUserProviderNotifierProvider = StateNotifierProvider.autoDispose<
        DeleteUserProviderNotifier, AppState<bool>>(
    (ref) => DeleteUserProviderNotifier(ref.read(authRemoteSourceProvider)));
