import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { empty, tooShort, notMatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({this.password = '', String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;

    if (value.length < 8) return ConfirmPasswordValidationError.tooShort;

    if (value != password) return ConfirmPasswordValidationError.notMatch;

    return null;
  }
}

extension ConfirmPasswordValidationErrorText on ConfirmPasswordValidationError {
  String text() {
    switch (this) {
      case ConfirmPasswordValidationError.empty:
        return '''Kata sandi tidak boleh kosong''';
      case ConfirmPasswordValidationError.tooShort:
        return '''Kata sandi minimum 8 karakter''';
      case ConfirmPasswordValidationError.notMatch:
        return '''Kata sandi tidak sama''';
    }
  }
}
