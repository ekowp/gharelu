import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byday/src/chat/data_source/chat_data_source.dart'; // Updated import for By Day branding.
import 'package:byday/src/chat/models/message_model.dart'; // Chat message model.
import 'package:byday/src/core/state/app_state.dart'; // State management utilities.
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A state notifier for sending messages.
/// This functionality is restricted to:
/// - Client ↔ Customer Service communication.
/// - Artisan ↔ Customer Service communication.
class SendMessageNotifier extends StateNotifier<AppState<bool>> {
  /// Constructor initializes the remote source and sets the initial state.
  SendMessageNotifier(this._remoteSource) : super(const AppState.initial());

  final ChatRemoteSource _remoteSource; // Remote source for chat-related Firestore operations.

  /// Sends a message to the Firestore database via the remote source.
  /// Only allows interaction between customer service and clients/artisans.
  Future<void> sendMessage({required MessageModel message}) async {
    // Update state to loading when message sending is in progress.
    state = const AppState.loading();

    // Invoke the remote source to send the message.
    final response = await _remoteSource.sendMessage(message: message);

    // Process the response and update the state accordingly.
    state = response.fold(
      (error) => error.when(
        serverError: (message) => AppState.error(message: message), // Handle server errors.
        noInternet: () => AppState.noInternet(), // Handle no internet connection errors.
      ),
      (success) => AppState.success(data: success), // Update state on success.
    );
  }
}

/// Provider for SendMessageNotifier.
/// Manages message sending functionality for customer service communication.
final sendMessageNotifierProvider =
    StateNotifierProvider<SendMessageNotifier, AppState<bool>>((ref) {
  // Initialize SendMessageNotifier and inject the remote source dependency.
  return SendMessageNotifier(ref.read(chatRemoteSourceProvider));
});
