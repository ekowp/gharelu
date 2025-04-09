import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:byday/src/auth/models/custom_user_model.dart';
import 'package:byday/src/core/constant/app_constant.dart';
import 'package:byday/src/core/errors/app_error.dart';
import 'package:byday/src/core/providers/firebase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthStatusDataSource {
  AuthStatusDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<Either<AppError, CustomUserModel>> authStatus({required String id}) async {
    try {
      // Check if the user exists in the normal users collection.
      final userSnapshot = await _firestore.collection(AppConstant.users).doc(id).get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        return right(CustomUserModel.fromJson(userSnapshot.data()!));
      }
      
      // Otherwise, check if the user exists in the merchants collection.
      final merchantSnapshot = await _firestore.collection(AppConstant.merchants).doc(id).get();
      if (merchantSnapshot.exists && merchantSnapshot.data() != null) {
        return right(CustomUserModel.fromJson(merchantSnapshot.data()!));
      }
      
      // If no record is found, return an authentication error.
      return left(const AppError.serverError(message: 'UnAuthenticated'));
    } on FirebaseAuthException catch (e) {
      return left(AppError.serverError(message: e.message ?? 'UnAuthenticated'));
    } on FirebaseException catch (e) {
      return left(AppError.serverError(message: e.message ?? 'UnAuthenticated'));
    }
  }
}

final authStatusDataSourceProvider = Provider<AuthStatusDataSource>((ref) {
  return AuthStatusDataSource(ref.read(firebaseProvider));
});
