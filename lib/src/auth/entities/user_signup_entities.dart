import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:byday/src/core/extensions/extensions.dart'; // Assumes extensions like .isEmail and .isPhone are defined here.
import 'package:byday/src/core/validations/field.dart';

part 'user_signup_entities.freezed.dart';

@freezed
class UserSignupFromEntity with _$UserSignupFromEntity {
  const UserSignupFromEntity._();
  const factory UserSignupFromEntity({
    required Field name,
    // Optional: Some users might have an email, but local phone number is primary.
    Field? email,
    // Local phone number—this is now the primary credential.
    required Field phoneNumber,
    required Field password,
    required Field confirmPassword,
    required Field location,
    // Optional MFA code for multi-factor authentication.
    Field? mfaCode,
  }) = _UserSignupFromEntity;

  factory UserSignupFromEntity.empty() => UserSignupFromEntity(
        name: Field(value: ''),
        email: Field(value: ''),
        phoneNumber: Field(value: ''),
        password: Field(value: ''),
        confirmPassword: Field(value: ''),
        location: Field(value: ''),
        mfaCode: Field(value: ''),
      );

  // Validate the optional email if provided; if left blank, it's considered valid.
  bool get isEmailValid => email?.value.toString().isEmail ?? true;

  // Validate local phone number. Ensure your String extension `isPhone` handles local phone formats.
  bool get isPhoneValid => phoneNumber.value.toString().isPhone;

  // Overall validity: name, phone, password, confirmPassword and location must be valid.
  // Email is optional and only validated if provided.
  bool get isValid =>
      name.isValid &&
      isPhoneValid &&
      password.isValid &&
      confirmPassword.isValid &&
      location.isValid;
}
