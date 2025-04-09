import 'package:equatable/equatable.dart';

/// Represents a help and support entity with relevant attributes.
/// Equatable ensures proper equality comparisons between entities.
class HelpAndSupportEntity extends Equatable {
  /// Creates a help and support entity with a name, content, and type.
  /// Includes validations for required attributes.
  const HelpAndSupportEntity({
    required this.name,
    required this.content,
    required this.type,
  })  : assert(name.isNotEmpty, 'Name cannot be empty'),
        assert(content.isNotEmpty, 'Content cannot be empty');

  /// Name or identifier of the help and support contact (e.g., "WhatsApp", "Email").
  final String name;

  /// Content associated with the help and support contact (e.g., URL, phone number, email).
  final String content;

  /// Type of help and support (e.g., Web, Mobile, Email).
  final UtilityEnum type;

  /// List of properties included for equality checks via Equatable.
  @override
  List<Object?> get props => [name, content, type];

  /// Converts the entity to a map, suitable for Firestore integration or JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
      'type': type.toString().split('.').last, // Converts enum to string value.
    };
  }

  /// Creates an instance from a map (e.g., Firestore document or JSON).
  factory HelpAndSupportEntity.fromMap(Map<String, dynamic> map) {
    return HelpAndSupportEntity(
      name: map['name'] as String,
      content: map['content'] as String,
      type: UtilityEnum.values.firstWhere((e) => e.toString().split('.').last == map['type']),
    );
  }
}

/// Enum representing the type of utility for help and support entities.
enum UtilityEnum { WEB, MOBILE, EMAIL }

extension UtilityEnumExtension on UtilityEnum {
  /// Converts the enum value to a user-friendly name.
  String get displayName {
    switch (this) {
      case UtilityEnum.WEB:
        return 'Web';
      case UtilityEnum.MOBILE:
        return 'Mobile';
      case UtilityEnum.EMAIL:
        return 'Email';
    }
  }
}
