import 'package:formz/formz.dart';

enum CafeNameValidationError { empty, tooShort }

class CafeName extends FormzInput<String, CafeNameValidationError> {
  const CafeName.pure() : super.pure('');
  const CafeName.dirty([super.value = '']) : super.dirty();

  @override
  CafeNameValidationError? validator(String value) {
    if (value.isEmpty) return CafeNameValidationError.empty;

    if (value.length < 4) return CafeNameValidationError.tooShort;

    return null;
  }
}

extension CafeNameValidationErrorToText on CafeNameValidationError {
  String text() {
    switch (this) {
      case CafeNameValidationError.empty:
        return '''Nama cafe tidak boleh kosong''';
      case CafeNameValidationError.tooShort:
        return '''Nama cafe minimum 4 karakter''';
    }
  }
}
