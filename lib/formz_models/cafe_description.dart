import 'package:formz/formz.dart';

enum CafeDescriptionValidationError { empty, tooShort }

class CafeDescription extends FormzInput<String, CafeDescriptionValidationError> {
  const CafeDescription.pure() : super.pure('');
  const CafeDescription.dirty([super.value = '']) : super.dirty();

  @override
  CafeDescriptionValidationError? validator(String value) {
    if (value.isEmpty) return CafeDescriptionValidationError.empty;

    if (value.length < 50) return CafeDescriptionValidationError.tooShort;

    return null;
  }
}

extension CafeDescriptionValidationErrorToText on CafeDescriptionValidationError {
  String text() {
    switch (this) {
      case CafeDescriptionValidationError.empty:
        return '''Deskripsi cafe tidak boleh kosong''';
      case CafeDescriptionValidationError.tooShort:
        return '''Deskripsikan cafemu minimum 50 karakter''';
    }
  }
}
