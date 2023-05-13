import 'package:formz/formz.dart';

enum FullNameValidationError { empty, tooShort }

class FullName extends FormzInput<String, FullNameValidationError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([super.value = '']) : super.dirty();

  @override
  FullNameValidationError? validator(String value) {
    if (value.isEmpty) return FullNameValidationError.empty;

    if (value.length < 4) return FullNameValidationError.tooShort;

    return null;
  }
}

extension FullNameValidationErrorToText on FullNameValidationError {
  String text() {
    switch (this) {
      case FullNameValidationError.empty:
        return '''Nama tidak boleh kosong''';
      case FullNameValidationError.tooShort:
        return '''Nama minimum 4 karakter''';
    }
  }
}
