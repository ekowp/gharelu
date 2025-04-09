import 'package:equatable/equatable.dart';

/// Represents a cancellation reason entity with relevant attributes.
/// Equality comparison is handled via Equatable for easy instance checks.
class CancellationReasonEntity extends Equatable {
  /// Creates a cancellation reason with a title, ID, and description.
  /// Includes validation for required attributes.
  CancellationReasonEntity({
    required this.title,
    required this.id,
    required this.description,
  })  : assert(title.isNotEmpty, 'Title cannot be empty'),
        assert(description.isNotEmpty, 'Description cannot be empty');

  /// The title or name of the cancellation reason.
  final String title;

  /// Unique identifier for the cancellation reason.
  final int id;

  /// Detailed description explaining the cancellation reason.
  final String description;

  /// List of properties included for equality checks via Equatable.
  @override
  List<Object?> get props => [title, id, description];

  /// Static method to create an instance from an enum value.
  static CancellationReasonEntity fromEnum(CancellationReasonType type) {
    switch (type) {
      case CancellationReasonType.incorrectAppointment:
        return CancellationReasonEntity(
          title: 'Incorrect Appointment',
          id: 1,
          description: 'The appointment was scheduled for the wrong date, time, or location.',
        );
      case CancellationReasonType.rescheduling:
        return CancellationReasonEntity(
          title: 'Rescheduling',
          id: 2,
          description: 'The individual needs to reschedule the appointment for a different date or time.',
        );
      case CancellationReasonType.conflictWithOwner:
        return CancellationReasonEntity(
          title: 'Conflict with Owner',
          id: 3,
          description: 'The individual has a conflict with the person or organization they were scheduled to meet with.',
        );
      case CancellationReasonType.other:
        return CancellationReasonEntity(
          title: 'Other',
          id: 4,
          description: 'There may be other reasons not listed here that are specific to the individual or the situation.',
        );
    }
  }

  /// Converts the entity to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'id': id,
      'description': description,
    };
  }

  /// Creates an instance from a Firestore map.
  factory CancellationReasonEntity.fromFirestore(Map<String, dynamic> map) {
    return CancellationReasonEntity(
      title: map['title'] as String,
      id: map['id'] as int,
      description: map['description'] as String,
    );
  }
}

/// Enum to define standardized cancellation reasons.
enum CancellationReasonType {
  incorrectAppointment, // The appointment was scheduled incorrectly.
  rescheduling, // The appointment needs to be rescheduled.
  conflictWithOwner, // Conflict with the meeting organizer.
  other, // Other reasons.
}

