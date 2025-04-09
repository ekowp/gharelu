import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byday/src/auth/models/custom_user_model.dart'; // Updated for By Day branding.
import 'package:byday/src/chat/models/message_model.dart'; // Chat message model.
import 'package:byday/src/chat/models/room_model.dart'; // Chat room model.
import 'package:byday/src/core/constant/app_constant.dart'; // App constants (e.g., Firestore collection paths).
import 'package:byday/src/core/errors/app_error.dart'; // App-specific error handling.
import 'package:byday/src/core/helpers/storage_helper.dart'; // Helper for uploading files to Firebase Storage.
import 'package:byday/src/core/providers/firbease_provider.dart'; // Firebase providers.
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../home/models/product_model.dart'; // Product details model.

/// Remote source for chat functionalities.
/// Handles Firestore operations for customer service-related messaging.
class ChatRemoteSource {
  ChatRemoteSource(this.firestore, this.firebaseAuth, this._ref);

  final FirebaseFirestore firestore; // Instance of Firestore for database operations.
  final FirebaseAuth firebaseAuth; // Instance of FirebaseAuth for user authentication.
  final Ref _ref; // Riverpod reference for dependency injection.

  /// Returns the current authenticated user ID.
  String? get userId => firebaseAuth.currentUser?.uid;

  /// Sends a message to the customer service chat room.
  /// Supports both text and image messages.
  Future<Either<AppError, bool>> sendMessage({required MessageModel message}) async {
    try {
      String? imageUrl;

      // Upload image if the message contains an image.
      if (message.type == MessageType.image) {
        imageUrl = await StorageHelper.uploadFile(
          _ref,
          File(message.imageUrl!), // Converts image path to a File instance.
          path: 'chats', // Specifies the folder in Firebase Storage.
        );
      }

      final now = DateTime.now().millisecondsSinceEpoch; // Current timestamp.
      final ref = firestore.collection(AppConstant.messages); // Reference to the messages collection.

      // Create and save the message in Firestore with a generated ID.
      await ref.doc(ref.doc().id).set(
        message.copyWith(
          id: ref.doc().id, // Unique message ID.
          imageUrl: imageUrl, // Updated image URL (if applicable).
          createdAt: now, // Timestamp for message creation.
        ).toJson(),
      );

      return right(true); // Successfully sent message.
    } on FirebaseAuthException catch (e) {
      return left(AppError.serverError(message: e.message ?? 'Failed to send message.'));
    }
  }

  /// Creates a new chat room for customer service communication.
  Future<Either<AppError, String>> createChatRoom({required RoomModel room}) async {
    try {
      final ref = firestore.collection(AppConstant.rooms); // Reference to chat rooms collection.

      // Save the room information in Firestore with a generated ID.
      await ref.doc(ref.doc().id).set(
        room.copyWith(id: ref.doc().id).toJson(),
      );

      return right(ref.doc().id); // Successfully created chat room.
    } on FirebaseAuthException catch (e) {
      return left(AppError.serverError(message: e.message ?? 'Failed to create chat room.'));
    } on FirebaseException catch (e) {
      return left(AppError.serverError(message: e.message ?? 'Failed to create chat room.'));
    }
  }
}

/// Provides the `ChatRemoteSource` instance using Riverpod.
/// Ensures dependency injection for Firestore and FirebaseAuth.
final chatRemoteSourceProvider = Provider<ChatRemoteSource>((ref) {
  return ChatRemoteSource(
    ref.read(firestoreProvider), // Firestore provider.
    ref.read(firebaseAuthProvider), // FirebaseAuth provider.
    ref, // Riverpod reference.
  );
});

/// Retrieves user information by user ID.
Future<CustomUserModel> getUserInfo(Ref ref, String userId) async {
  final firestore = ref.read(firestoreProvider); // Firestore instance.
  final response = await firestore
      .collection(AppConstant.users) // Users collection.
      .doc(userId) // Specific user document.
      .get();

  // Converts Firestore document data into a CustomUserModel instance.
  return CustomUserModel.fromJson(response.data()!);
}

/// Retrieves artisan information by artisan ID.
Future<CustomUserModel> getArtisanInfo(Ref ref, String artisanId) async {
  final firestore = ref.read(firestoreProvider); // Firestore instance.
  final response = await firestore
      .collection(AppConstant.artisans) // Artisans collection.
      .doc(artisanId) // Specific artisan document.
      .get();

  // Converts Firestore document data into a CustomUserModel instance.
  return CustomUserModel.fromJson(response.data()!);
}

/// Streams the latest message in a customer service chat room.
/// Retrieves the latest message by filtering messages based on room ID.
Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(Ref ref, String roomId) {
  final firestore = ref.read(firestoreProvider); // Firestore instance.

  // Query for messages in the specified room, ordered by timestamp.
  return firestore
      .collection(AppConstant.messages) // Messages collection.
      .where('room_id', isEqualTo: roomId) // Filter by room ID.
      .orderBy('created_at', descending: true) // Order by latest messages.
      .snapshots();
}

/// Retrieves product information by product ID.
Future<ProductModel> getProductInfo(Ref ref, String productId) async {
  final firestore = ref.read(firestoreProvider); // Firestore instance.
  final response = await firestore
      .collection(AppConstant.products) // Products collection.
      .doc(productId) // Specific product document.
      .get();

  // Converts Firestore document data into a ProductModel instance.
  return ProductModel.fromJson(response.data()!);
}
