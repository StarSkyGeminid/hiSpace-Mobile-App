import 'package:formz/formz.dart';

enum CafeAddressValidationError { empty, tooShort }

class CafeAddress extends FormzInput<String, CafeAddressValidationError> {
  const CafeAddress.pure() : super.pure('');
  const CafeAddress.dirty([super.value = '']) : super.dirty();

  @override
  CafeAddressValidationError? validator(String value) {
    if (value.isEmpty) return CafeAddressValidationError.empty;

    if (value.length < 4) return CafeAddressValidationError.tooShort;

    return null;
  }
}

extension CafeAddressValidationErrorToText on CafeAddressValidationError {
  String text() {
    switch (this) {
      case CafeAddressValidationError.empty:
        return '''Alamat cafe tidak boleh kosong''';
      case CafeAddressValidationError.tooShort:
        return '''Alamat cafe minimum 4 karakter''';
    }
  }
}
