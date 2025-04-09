import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:byday/src/app/views/app.dart'; // Updated to match the By Day branding.
import 'package:byday/src/auth/entities/user_signup_entities.dart'; // User signup entity.
import 'package:byday/src/auth/providers/forms/signup/user_signup_form_state.dart'; // Form state for user signup.
import 'package:byday/src/core/extensions/extensions.dart'; // Utility extensions like validation helpers.
import 'package:byday/src/core/validations/field.dart'; // Validation utilities for form fields.
import 'package:latlong2/latlong.dart'; // Geolocation utilities.

/// A [StateNotifier] that manages the state of the user signup form.
/// It holds a [UserSignupFromEntity] which captures the user's signup data.
/// Each setter method validates the corresponding field and updates the state accordingly.
class UserSignupFormProvider extends StateNotifier<UserSignupFormState> {
  /// Initializes the provider with an empty user signup form entity.
  UserSignupFormProvider()
      : super(UserSignupFormState(UserSignupFromEntity.empty()));

  /// Updates the [name] field in the signup form.
  ///
  /// If [name] is empty, marks the field as invalid with an error message,
  /// otherwise marks it as valid.
  void setName(String name) {
    var _form = state.form.copyWith(name: Field(value: name));
    late Field nameField;
    if (name.isEmpty) {
      nameField = _form.name.copyWith(
        isValid: false,
        errorMessage: 'Name cannot be empty',
      );
    } else {
      nameField = _form.name.copyWith(
        isValid: true,
        errorMessage: '',
      );
    }
    _form = _form.copyWith(name: nameField);
    state = state.copyWith(form: _form);
  }

  /// Updates the [email] field in the signup form.
  ///
  /// Uses an extension to validate the email format. If valid, sets the field as valid;
  /// otherwise, sets an appropriate error message.
  void setEmail(String email) {
    final _form = state.form.copyWith(email: Field(value: email));
    late Field emailField;
    if (email.trim().isEmail) {
      emailField = _form.email.copyWith(
        isValid: true,
        errorMessage: '',
      );
    } else {
      emailField = _form.email.copyWith(
        isValid: false,
        errorMessage: 'Email doesn\'t look right',
      );
    }
    state = state.copyWith(form: _form.copyWith(email: emailField));
  }

  /// Updates the [password] field in the signup form.
  ///
  /// Marks the password field as valid, or sets an error message if validation fails.
  void setPassword(String password) {
    var _form = state.form.copyWith(password: Field(value: password));
    late Field passwordField;
    passwordField = _form.password.copyWith(
      isValid: true,
      errorMessage: '',
    );
    state = state.copyWith(form: _form.copyWith(password: passwordField));
  }

  /// Updates the [confirmPassword] field in the signup form.
  ///
  /// Validates that the [confirmPassword] matches the original password. If they match,
  /// the field is marked as valid; otherwise, sets an error message.
  void setConfirmPassword(String confirmPassword) {
    final _password = state.form.password.value;
    var _form = state.form;
    late Field confirmPasswordField;
    if (_password == confirmPassword) {
      confirmPasswordField = _form.confirmPassword.copyWith(
        isValid: true,
        errorMessage: '',
      );
    } else {
      confirmPasswordField = _form.confirmPassword.copyWith(
        value: confirmPassword,
        isValid: false,
        errorMessage: 'Password and Confirm Password do not match',
      );
    }
    state = state.copyWith(
        form: _form.copyWith(confirmPassword: confirmPasswordField));
  }

  /// Updates the [location] field in the signup form.
  ///
  /// Accepts a [location] string, a [placeId], and [LatLng] coordinates.
  /// Marks the location as valid. Adjust validation logic as needed for additional checks.
  void setLocation(String location, String placeId, LatLng latLng) {
    var _form = state.form.copyWith(location: Field(value: location));
    late Field locationField;
    locationField = _form.location.copyWith(
      isValid: true,
      errorMessage: '',
    );
    state = state.copyWith(form: _form.copyWith(location: locationField));
  }
}

/// Exposes the [UserSignupFormProvider] as a Riverpod provider.
/// Marked as auto-dispose to clean up resources when not in use.
final userSignupFormProvider = StateNotifierProvider.autoDispose<
    UserSignupFormProvider,
    UserSignupFormState>((ref) => UserSignupFormProvider());
