import 'package:byday/src/core/entity/cancellation_reason_entity.dart'; // Updated for By Day branding.
import 'package:byday/src/core/entity/help_and_support_entity.dart'; // Updated for By Day branding.

/// `AppConstant` class serves as a centralized repository for static constants used throughout the app.
/// This class minimizes hardcoding and improves maintainability.
class AppConstant {
  /// Private constructor to prevent instantiation.
  const AppConstant._();

  // Firestore collection names
  static const String users = 'users'; // Collection for user data.
  static const String merchants = 'merchants'; // Collection for artisan/merchant data.
  static const String banners = 'banners'; // Collection for promotional banners.
  static const String services = 'services'; // Collection for service listings.
  static const String feedback = 'feedback'; // Collection for user feedback.
  static const String rooms = 'rooms'; // Collection for chat rooms.
  static const String messages = 'messages'; // Collection for chat messages.
  static const String categories = 'categories'; // Collection for service categories.
  static const String products = 'products'; // Collection for product information.

  /// List of cancellation reasons, providing structured data for form dropdowns or other UI elements.
  static const List<CancellationReasonEntity> cancellationReasons = [
    CancellationReasonEntity(
      title: 'Incorrect Appointment',
      id: 1,
      description: 'The appointment was scheduled for the wrong date, time, or location.',
    ),
    CancellationReasonEntity(
      title: 'Rescheduling',
      id: 2,
      description: 'The individual needs to reschedule the appointment for a different date or time.',
    ),
    CancellationReasonEntity(
      title: 'Conflict with Owner',
      id: 3,
      description: 'The individual has a conflict with the person or organization they were scheduled to meet with.',
    ),
    CancellationReasonEntity(
      title: 'Other',
      id: 4,
      description: 'There may be other reasons not listed here that are specific to the individual or the situation.',
    ),
  ];

  /// List of help and support contacts for quick access.
  /// Each entity includes a name, content (URL, email, or phone number), and type.
  static const List<HelpAndSupportEntity> helpAndSupport = [
    HelpAndSupportEntity(
      name: 'Facebook Messenger',
      content: 'https://me.m/theaayushb', // Example URL for Messenger.
      type: UtilityEnum.WEB,
    ),
    HelpAndSupportEntity(
      name: 'WhatsApp',
      content: 'https://web.whatsapp.com/+233123456789', // WhatsApp link with Ghana placeholder.
      type: UtilityEnum.WEB,
    ),
    HelpAndSupportEntity(
      name: 'Viber',
      content: 'https://viber.com', // Example Viber link.
      type: UtilityEnum.WEB,
    ),
    HelpAndSupportEntity(
      name: 'Call +233123456789',
      content: '+233123456789', // Local Ghanaian placeholder phone number.
      type: UtilityEnum.MOBILE,
    ),
    HelpAndSupportEntity(
      name: 'Email',
      content: 'support@example.com', // Example support email.
      type: UtilityEnum.EMAIL,
    ),
  ];
}

/// Enumerates the types of messages supported in the chat functionality.
enum MessageType {
  text, // Text-based messages.
  image, // Image-based messages.
}
