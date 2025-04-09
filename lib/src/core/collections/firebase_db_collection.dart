import 'package:cloud_firestore/cloud_firestore.dart';

/// FirebaseDBCollection is a centralized class for managing Firestore collections.
/// This ensures easy access and minimizes hardcoded collection paths throughout the app.
class FirebaseDBCollection {
  /// Private constructor to prevent instantiation.
  const FirebaseDBCollection._();

  /// Firestore collection for user data.
  static CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');

  /// Firestore collection for service listings.
  static CollectionReference<Map<String, dynamic>> services =
      FirebaseFirestore.instance.collection('services');

  /// Firestore collection for booking records.
  static CollectionReference<Map<String, dynamic>> bookings =
      FirebaseFirestore.instance.collection('bookings');

  /// Firestore collection for product information.
  static CollectionReference<Map<String, dynamic>> products =
      FirebaseFirestore.instance.collection('products');
}

