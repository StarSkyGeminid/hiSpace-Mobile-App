import 'package:formz/formz.dart';

enum CafeReviewValidationError { empty, tooShort }

class CafeReview extends FormzInput<String, CafeReviewValidationError> {
  const CafeReview.pure() : super.pure('');
  const CafeReview.dirty([super.value = '']) : super.dirty();

  @override
  CafeReviewValidationError? validator(String value) {
    if (value.isEmpty) return CafeReviewValidationError.empty;

    if (value.length < 10) return CafeReviewValidationError.tooShort;

    return null;
  }
}

extension ReviewValidationErrorToText on CafeReviewValidationError {
  String text() {
    switch (this) {
      case CafeReviewValidationError.empty:
        return '''Review tidak boleh kosong''';
      case CafeReviewValidationError.tooShort:
        return '''Review minimum 10 karakter''';
    }
  }
}
