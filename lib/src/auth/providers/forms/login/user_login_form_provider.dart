import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:byday/src/app/views/app.dart';
import 'package:byday/src/auth/entities/user_login_entity.dart';
import 'package:byday/src/auth/providers/forms/login/user_login_form_state.dart';
import 'package:byday/src/core/extensions/extensions.dart';
import 'package:byday/src/core/validations/field.dart';

/// A [StateNotifier] that manages the state of the user login form.
/// Maintains a [UserLoginEntity] which holds the user's email and password,
/// and updates the state as the user enters their credentials.
class UserLoginFormProvider extends StateNotifier<UserLoginFormState> {
  /// Initializes the provider with an empty [UserLoginEntity].
  UserLoginFormProvider() : super(UserLoginFormState(UserLoginEntity.empty()));

  /// Updates the email field in the login form.
  ///
  /// This method creates a new copy of the form with the updated email value.
  /// Then, it checks if the trimmed email string is valid using the [isEmail] extension.
  /// If valid, it marks the email field as valid; otherwise, it sets an appropriate error message.
  void setEmail(String email) {
    // Create a new copy of the form with the updated email value.
    UserLoginEntity updatedForm = state.form.copyWith(
      email: Field(value: email),
    );
    
    // Create a new Field for the email after validation.
    late Field emailField;
    if (email.trim().isEmail) {
      emailField = updatedForm.email.copyWith(isValid: true, errorMessage: '');
    } else {
      emailField = updatedForm.email.copyWith(
        isValid: false,
        errorMessage: 'Oops, email is not valid',
      );
    }
    
    // Update the state with the new form copy
    state = state.copyWith(form: updatedForm.copyWith(email: emailField));
  }

  /// Updates the password field in the login form.
  ///
  /// This method creates a new copy of the form with the updated password value.
  /// It then checks if the password is not empty. If the password is non-empty,
  /// it marks the password field as valid; otherwise, it sets an error message.
  void setPassword(String password) {
    // Create a new copy of the form with the updated password value.
    var updatedForm = state.form.copyWith(password: Field(value: password));
    
    // Create a new Field for the password after basic validation.
    late Field passwordField;
    if (password.isNotEmpty) {
      passwordField = updatedForm.password.copyWith(isValid: true, errorMessage: '');
    } else {
      passwordField = updatedForm.password.copyWith(
        isValid: false,
        errorMessage: 'Enter a valid password',
      );
    }
    
    // Update the state with the new form copy.
    state = state.copyWith(form: updatedForm.copyWith(password: passwordField));
  }
}

/// Riverpod provider that exposes the [UserLoginFormProvider].
/// This provider is marked as auto-dispose, which means it will be disposed
/// when it's no longer needed.
final userLoginFormProvider = StateNotifierProvider.autoDispose<
    UserLoginFormProvider,
    UserLoginFormState>((ref) => UserLoginFormProvider());
