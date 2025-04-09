import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byday/src/chat/models/message_model.dart'; // Updated path for By Day branding.
import 'package:byday/src/core/constant/app_constant.dart'; // Centralized constants (e.g., Firestore collections).
import 'package:byday/src/core/extensions/list_extension.dart'; // Extensions for list operations.
import 'package:byday/src/core/providers/firbease_provider.dart'; // Firebase dependency injection.
import 'package:byday/src/core/state/app_state.dart'; // State management utilities.
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A state notifier for managing messages in a chat room.
/// Ensures communication is exclusively between:
/// - Client and Customer Service.
/// - Artisan and Customer Service.
class GetMessageNotifier extends StateNotifier<AppState<List<MessageModel>>> {
  /// Constructor initializes Firestore, FirebaseAuth, and Riverpod Ref.
  GetMessageNotifier(this._firestore, this._firebaseAuth, this.ref)
      : super(const AppState.initial());

  final FirebaseFirestore _firestore; // Instance of Firestore for database operations.
  final FirebaseAuth _firebaseAuth; // Instance of FirebaseAuth for authentication.
  final Ref ref; // Riverpod Ref for managing dependencies.

  /// Fetches messages from a chat room based on the room ID.
  /// Messages are sorted by the time they were created, with the latest first.
  void getMessages({required String roomId}) {
    state = const AppState.loading(); // Sets the state to loading.

    // List to store all fetched messages.
    List<MessageModel> messages = [];

    // Watch for changes in the `messages` collection for the given room ID.
    _firestore
        .collection(AppConstant.messages) // Reference to Firestore messages collection.
        .where('room_id', isEqualTo: roomId) // Filter messages by room ID.
        .orderBy('created_at', descending: true) // Order messages by creation time (latest first).
        .snapshots()
        .listen((event) async {
      // Map Firestore documents to MessageModel instances.
      messages =
          List<MessageModel>.from(event.docs.map((e) => MessageModel.fromJson(e.data())));

      // Process each message to ensure compliance with the app's communication design.
      for (var message in messages) {
        final index = messages.indexOf(message);

        // Remove any references to client-artisan communication.
        // Only interactions between customer service and clients/artisans are retained.
        final _message = messages[index].copyWith();

        // Update the message in the list.
        messages.update(index, _message);

        // Update state with the processed message list.
        state = AppState.success(data: messages);
      }

      // Final state update with the list of messages.
      state = AppState.success(data: messages);
    });
  }
}

/// Provider for GetMessageNotifier.
/// Fetches messages for a specific room ID while ensuring communication compliance.
final getMessagesNotifierProvider =
    StateNotifierProvider.family<GetMessageNotifier, AppState<List<MessageModel>>, String>((ref, roomId) {
  // Initialize GetMessageNotifier and fetch messages for the given room ID.
  return GetMessageNotifier(
    ref.read(firestoreProvider), // Inject Firestore instance.
    ref.read(firebaseAuthProvider), // Inject FirebaseAuth instance.
    ref,
  )..getMessages(roomId: roomId);
});
