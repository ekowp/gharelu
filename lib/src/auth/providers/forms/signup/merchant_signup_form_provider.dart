import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:byday/src/app/views/app.dart'; // Updated for byday branding.
import 'package:byday/src/auth/entities/merchant_signup_entities.dart'; // Merchant signup entity.
import 'package:byday/src/auth/providers/forms/signup/merchant_signup_form_state.dart'; // Form state for merchant signup.
import 'package:byday/src/core/extensions/extensions.dart'; // Custom extensions (e.g., validation utilities).
import 'package:byday/src/core/validations/field.dart'; // Field validation utilities.

/// A [StateNotifier] that manages the state of the merchant signup form.
/// It holds a [MerchantSignupFromEntity] which captures the merchant's signup data.
/// Each setter method validates the corresponding field and updates the state accordingly.
class MerchantSignupFormProvider extends StateNotifier<MerchantSignupFormState> {
  /// Initializes the provider with an empty merchant signup form entity.
  MerchantSignupFormProvider()
      : super(MerchantSignupFormState(MerchantSignupFromEntity.empty()));

  /// Updates the [name] field in the signup form.
  ///
  /// If [name] is empty, marks the field as invalid with an error message,
  /// otherwise marks it as valid.
  void setName(String name) {
    // Create a copy of the form with the new name value.
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
  /// Checks whether the password is at least 5 characters long. Marks as valid if yes,
  /// otherwise sets an error message indicating the password is not strong enough.
  void setPassword(String password) {
    final _form = state.form.copyWith(password: Field(value: password));
    late Field passwordField;
    if (password.length > 4) {
      passwordField = _form.password.copyWith(
        isValid: true,
        errorMessage: '',
      );
    } else {
      passwordField = _form.password.copyWith(
        isValid: false,
        errorMessage: 'Password is not strong',
      );
    }
    state = state.copyWith(form: _form.copyWith(password: passwordField));
  }

  /// Updates the [phoneNumber] field in the signup form.
  ///
  /// Checks whether the phone number length is greater than 5. If valid, marks it valid;
  /// otherwise, sets an error message.
  void setPhoneNumber(String phoneNumber) {
    final _form = state.form.copyWith(phoneNumber: Field(value: phoneNumber));
    late Field phoneNumberField;
    if (phoneNumber.length > 5) {
      phoneNumberField = _form.phoneNumber.copyWith(
        isValid: true,
        errorMessage: '',
      );
    } else {
      phoneNumberField = _form.phoneNumber.copyWith(
        isValid: false,
        errorMessage: 'Enter valid phone number',
      );
    }
    state = state.copyWith(
      form: _form.copyWith(phoneNumber: phoneNumberField),
    );
  }

  /// Updates the [location] field in the signup form.
  ///
  /// In this simple validation, the location is always marked as valid.
  void setLocation(String location) {
    final _form = state.form.copyWith(location: Field(value: location));
    // Marking location as valid without additional checks. Adjust as needed.
    final locationField = _form.location.copyWith(
      isValid: true,
      errorMessage: '',
    );
    state = state.copyWith(form: _form.copyWith(location: locationField));
  }

  /// Updates the [documents] field in the signup form.
  ///
  /// Converts a list of document Strings into a list of [Field]s and marks them as valid.
  void setDocuments(List<String> documents) {
    final _form = state.form.copyWith(
      documents: documents.map((doc) => Field(value: doc)).toList(),
    );
    final documentsField = _form.documents
        .map((e) => e.copyWith(isValid: true, errorMessage: ''))
        .toList();
    state = state.copyWith(form: _form.copyWith(documents: documentsField));
  }

  /// Removes a document [Field] from the documents list.
  void removeDocument(Field docField) {
    var updatedDocuments = List<Field>.from(state.form.documents);
    updatedDocuments.remove(docField);
    state = state.copyWith(
      form: state.form.copyWith(documents: updatedDocuments),
    );
  }
}

/// Exposes the [MerchantSignupFormProvider] as a Riverpod provider.
/// Marked as auto-dispose to clean up resources when not in use.
final merchantSignupFormProvider =
    StateNotifierProvider.autoDispose<MerchantSignupFormProvider, MerchantSignupFormState>(
  (ref) => MerchantSignupFormProvider(),
);
