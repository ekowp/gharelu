import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:byday/src/auth/entities/merchant_signup_entities.dart';

part 'merchant_signup_form_state.freezed.dart';

@freezed
class MerchantSignupFormState with _$MerchantSignupFormState {
  const factory MerchantSignupFormState(MerchantSignupFromEntity form) = _MerchantSignupFormState;
}
