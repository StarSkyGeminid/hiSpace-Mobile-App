import 'package:formz/formz.dart';

enum ReviewValidationError { empty, tooShort }

class Review extends FormzInput<String, ReviewValidationError> {
  const Review.pure() : super.pure('');
  const Review.dirty([super.value = '']) : super.dirty();

  @override
  ReviewValidationError? validator(String value) {
    if (value.isEmpty) return ReviewValidationError.empty;

    if (value.length < 10) return ReviewValidationError.tooShort;

    return null;
  }
}

extension ReviewValidationErrorToText on ReviewValidationError {
  String text() {
    switch (this) {
      case ReviewValidationError.empty:
        return '''Review tidak boleh kosong''';
      case ReviewValidationError.tooShort:
        return '''Review minimum 10 karakter''';
    }
  }
}
