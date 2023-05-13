import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;

    if (value.length < 8) return PasswordValidationError.tooShort;

    return null;
  }
}

extension PasswordValidationErrorText on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.empty:
        return '''Kata sandi tidak boleh kosong''';
      case PasswordValidationError.tooShort:
        return '''Kata sandi minimum 8 karakter''';
    }
  }
}
