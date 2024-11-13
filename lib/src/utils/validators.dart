import 'package:form_field_validator/form_field_validator.dart';

import '../helpers/general_helper.dart';

var requiredValidator =
    RequiredValidator(errorText: trans().thisFieldIsRequired);

var nameValidator = RequiredValidator(errorText: trans().nameFieldIsRequired);

emailValidator({bool isRequired = true}) => MultiValidator([
      if (isRequired)
        RequiredValidator(errorText: trans().emailFieldIsRequired),
      EmailValidator(errorText: trans().thisIsNotAValidEmail)
    ]);

var passwordValidator =
    RequiredValidator(errorText: trans().passwordFieldIsRequired);

var newPasswordValidator =
    RequiredValidator(errorText: trans().newPasswordFieldIsRequired);

String? confirmNewPasswordValidator(String? value, String? newPassword) {
  if (value?.isEmpty ?? true) return trans().confirmNewPasswordFieldIsRequired;

  if (value != newPassword) return trans().notMatchedWithNewPassword;

  return null;
}

String? passwordConfirmationValidator(String value, String value2) =>
    MatchValidator(
      errorText: trans().passwordsDoNotMatch,
    ).validateMatch(value, value2);

phoneValidator({bool isRequired = true}) => MultiValidator([
      if (isRequired)
        RequiredValidator(errorText: trans().phoneFieldIsRequired),
      PatternValidator(r'\d', errorText: trans().phoneFieldAcceptsDigitsOnly)
    ]);

integerValidator({bool isRequired = true}) => MultiValidator([
      if (isRequired) RequiredValidator(errorText: trans().thisFieldIsRequired),
      PatternValidator(r'\d', errorText: trans().thisFieldAcceptsDigitsOnly)
    ]);

numericValidator({bool isRequired = true}) => MultiValidator([
      if (isRequired) RequiredValidator(errorText: trans().thisFieldIsRequired),
      PatternValidator(r'^\d+(\.\d+)?$',
          errorText: trans().thisFieldAcceptsDigitsOnly)
    ]);

yearValidator({required bool isRequired}) => MultiValidator([
      if (isRequired) RequiredValidator(errorText: trans().thisFieldIsRequired),
      PatternValidator(r'^\d+(\.\d+)?$',
          errorText: trans().thisFieldAcceptsDigitsOnly),
    ]);
