import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:byday/src/auth/models/custom_user_model.dart'; // Updated import for By Day branding.
import 'package:byday/src/home/models/product_model.dart'; // Product details model.

part 'room_model.g.dart';
part 'room_model.freezed.dart';

/// Defines the structure for chat rooms in the app.
/// Chat rooms enable communication only between customer service and:
/// - Clients
/// - Artisans
@freezed
class RoomModel with _$RoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RoomModel({
    /// Unique identifier for the chat room.
    required String id,

    /// ID of the user (client) involved in the chat.
    required String userId,

    /// ID of the artisan involved in the chat with customer service.
    required String artisanId,

    /// ID of the product associated with the chat (if applicable).
    required String productId,

    /// Optional details of the client.
    CustomUserModel? user,

    /// Optional details of the artisan.
    CustomUserModel? artisan,

    /// Timestamp for when the chat room was created (optional).
    int? createdAt,

    /// Timestamp for the last update to the chat room.
    int? updatedAt,

    /// Optional details of the product associated with the chat.
    ProductModel? product,
  }) = _RoomModel;

  /// Generates a `RoomModel` instance from a JSON object.
  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
