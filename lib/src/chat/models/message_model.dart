import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:byday/src/auth/models/custom_user_model.dart'; // Updated import for By Day branding.
import 'package:byday/src/core/constant/app_constant.dart'; // Updated import for By Day branding.

part 'message_model.g.dart';
part 'message_model.freezed.dart';

/// Defines the structure for chat messages in the app.
/// Supports communication between:
/// - Client and Customer Service.
/// - Artisan and Customer Service.
@freezed
class MessageModel with _$MessageModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory MessageModel({
    /// Unique identifier for the message.
    required String id,

    /// ID of the user (client) sending or receiving the message.
    required String userId,

    /// ID of the artisan sending or receiving the message (for customer service communication only).
    required String artisanId,

    /// Optional text content of the message.
    String? message,

    /// Optional image URL for image-based messages.
    String? imageUrl,

    /// Specifies the type of the message (e.g., text, image).
    required MessageType type,

    /// ID of the chat room associated with the message.
    required String roomId,

    /// User details (optional, used for client information).
    CustomUserModel? user,

    /// Artisan details (optional, used for artisan information).
    CustomUserModel? artisan,

    /// ID of the sender (either the client or artisan interacting with customer service).
    required String senderId,

    /// Timestamp for message creation (optional).
    int? createdAt,

    /// Timestamp for the last update to the message.
    required int updatedAt,
  }) = _MessageModel;

  /// Generates a `MessageModel` instance from a JSON object.
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
