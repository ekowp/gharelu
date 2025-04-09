import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth SDK.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod state management.
import 'package:byday/src/auth/data_source/auth_remote_source.dart'; // Updated for By Day namespace.
import 'package:byday/src/core/state/app_state.dart'; // App state management utilities.

/// A [StateNotifier] that manages merchant signup and updates the app state.
/// Communicates with the remote authentication source to create a merchant account.
class MerchantSignupState extends StateNotifier<AppState<User?>> {
  /// Constructor initializing the notifier with an initial app state and Riverpod Ref.
  MerchantSignupState(this._reader) : super(const AppState.initial());

  /// Reference to the Riverpod [Ref] for dependency injection.
  final Ref _reader;

  /// Signs up a merchant user with the provided details.
  ///
  /// Parameters:
  /// - [email]: Merchant's email address.
  /// - [name]: Merchant's full name.
  /// - [phoneNumber]: Merchant's phone number.
  /// - [password]: Merchant's password.
  /// - [documents]: List of document files uploaded by the merchant.
  /// - [location]: Merchant's location (e.g., city, region).
  ///
  /// Updates the app state to reflect the signup process:
  /// - Sets the state to loading initially.
  /// - Calls the [merchantSignup] method on the remote source.
  /// - Updates the state to either success or error based on the response.
  Future signupAsMerchant({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
    required List<File> documents,
    required String location,
  }) async {
    // Set the state to loading while the signup operation is in progress.
    state = const AppState.loading();

    // Perform the signup operation via the remote source.
    final response =
        await _reader.read(authRemoteSourceProvider).merchantSignup(
              email: email,
              name: name,
              phoneNumber: phoneNumber,
              password: password,
              documents: documents,
              location: location,
            );

    // Update the state based on the signup response.
    state = response.fold(
      (error) => error.when(
          serverError: (message) => AppState.error(message: message),
          noInternet: () => const AppState.noInternet()),
      (response) => AppState.success(data: response),
    );
  }
}

/// Exposes the [MerchantSignupState] as a Riverpod provider.
/// The provider is auto-disposed to clean up resources when not in use.
final merchantSignupProvider =
    StateNotifierProvider.autoDispose<MerchantSignupState, AppState<User?>>(
        (ref) => MerchantSignupState(ref));
