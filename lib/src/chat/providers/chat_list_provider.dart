import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byday/src/chat/data_source/chat_data_source.dart'; // Updated for By Day branding.
import 'package:byday/src/chat/models/message_model.dart'; // Chat message model.
import 'package:byday/src/chat/models/room_model.dart'; // Chat room model.
import 'package:byday/src/core/constant/app_constant.dart'; // Centralized constants for Firestore collections.
import 'package:byday/src/core/extensions/list_extension.dart'; // For List operations (e.g., updating items).
import 'package:byday/src/core/providers/firbease_provider.dart'; // Firebase dependency injection.
import 'package:byday/src/core/state/app_state.dart'; // For managing app state.
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A state notifier for managing the list of chat rooms.
/// Designed for interactions with customer service ONLY:
/// - Client and Customer Service.
/// - Artisan and Customer Service.
class ChatListNotifier extends StateNotifier<AppState<List<RoomModel>>> {
  /// Constructor initializes Firestore, FirebaseAuth, and Riverpod Ref.
  ChatListNotifier(this._firestore, this._firebaseAuth, this.ref) : super(const AppState.initial());

  final FirebaseFirestore _firestore; // Firestore instance for database queries.
  final FirebaseAuth _firebaseAuth; // FirebaseAuth instance for authentication.
  final Ref ref; // Riverpod Ref for managing dependencies.

  /// Retrieves the ID of the currently authenticated user.
  String? get userId => _firebaseAuth.currentUser?.uid;

  /// Fetches the list of chat rooms where customer service is involved.
  /// This ensures that:
  /// - Clients can only communicate with Customer Service.
  /// - Artisans can only communicate with Customer Service.
  /// Communication between Clients and Artisans is strictly prohibited.
  void getChatList({required bool isArtisan}) async {
    state = const AppState.loading();

    // List to hold all fetched rooms.
    List<RoomModel> rooms = [];

    // Watch for changes in the `rooms` collection for customer service communication.
    await _firestore
        .collection(AppConstant.rooms) // Firestore collection for chat rooms.
        .where(isArtisan ? 'artisan_id' : 'user_id', isEqualTo: userId) // Filter by artisan or client ID.
        .snapshots()
        .listen((event) async {
      // Map Firestore documents to RoomModel instances.
      rooms = List<RoomModel>.from(event.docs.map((e) => RoomModel.fromJson(e.data())));

      // Process each room to fetch user, artisan, and product details.
      for (var i = 0; i < rooms.length; i++) {
        final room = rooms[i];

        // Fetch user (client) information.
        final user = await getUserInfo(ref, room.userId);

        // Fetch artisan information (if applicable).
        final artisan = await getArtisanInfo(ref, room.artisanId);

        // Fetch product information associated with the chat (if applicable).
        final product = await getProductInfo(ref, room.productId);

        // Update the room with additional details and refresh the state.
        final updatedRoom = room.copyWith(user: user, artisan: artisan, product: product);
        rooms.update(i, updatedRoom);

        // Update state with the processed room list.
        state = AppState.success(data: rooms);
      }
    });
  }
}

/// Provider for ChatListNotifier.
/// This manages the chat list for customer service interactions.
final chatListNotifierProvider = StateNotifierProvider.family<
    ChatListNotifier,
    AppState<List<RoomModel>>,
    bool>((ref, isArtisan) {
  // Initialize ChatListNotifier and fetch chat rooms.
  return ChatListNotifier(
    ref.read(firestoreProvider), // Inject Firestore instance.
    ref.read(firebaseAuthProvider), // Inject FirebaseAuth instance.
    ref,
  )..getChatList(isArtisan: isArtisan); // Specify if fetching for an artisan.
});
