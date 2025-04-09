import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:byday/src/core/enum/auth_type.dart';

part 'custom_user_model.g.dart';
part 'custom_user_model.freezed.dart';

/// The [CustomUserModel] represents a user's profile information in the app.
/// It is designed to be immutable and easily serializable to and from JSON.
/// Using the [Freezed] package allows us to have union types, immutability, and built-in copyWith methods.
@freezed
class CustomUserModel with _$CustomUserModel {
  // Private constructor required by Freezed.
  const CustomUserModel._();

  /// The main factory constructor with JSON serialization settings.
  ///
  /// The [@JsonSerializable] annotation:
  /// - Converts field names to snake_case when serializing to JSON.
  /// - Uses the explicitToJson flag so that nested objects (if any) are properly converted.
  const factory CustomUserModel({
    /// Unique identifier for the user.
    required String uid,

    /// The user's full name.
    required String name,

    /// The user's email address.
    required String email,

    /// Optional phone number of the user.
    String? phoneNumber,

    /// User's location (e.g., city, region).
    required String location,

    /// Optional creation timestamp (milliseconds since epoch).
    int? createdAt,

    /// Required last update timestamp (milliseconds since epoch).
    required int updatedAt,

    /// If true, the user is registered as a merchant. Defaults to false.
    @Default(false) bool isMerchant,

    /// Optional list of document URLs or identifiers associated with the user.
    /// Defaults to an empty list.
    @Default([]) List<String>? documents,

    /// The type of authentication used by the user (e.g., standard user, merchant).
    AuthType? authType,
  }) = _CustomUserModel;

  /// A factory constructor that creates a new [CustomUserModel] instance from a JSON map.
  factory CustomUserModel.fromJson(Map<String, dynamic> json) =>
      _$CustomUserModelFromJson(json);

  // ---------------------------------------------------------------------------
  // Optional: Convenience getters for working with timestamp fields.
  // Uncomment these if you need to convert the timestamps to [DateTime] objects.

  // /// Returns the creation date as a [DateTime] object, or null if [createdAt] is not set.
  // DateTime? get createdDate =>
  //     createdAt != null ? DateTime.fromMillisecondsSinceEpoch(createdAt!) : null;

  // /// Returns the last updated date as a [DateTime] object.
  // DateTime get updatedDate =>
  //     DateTime.fromMillisecondsSinceEpoch(updatedAt);
}
