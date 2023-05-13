part of 'register_bloc.dart';

enum RegisterPage { first, second }

class RegisterState extends Equatable {
  const RegisterState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isFirstPageValidated = false,
    this.isSecondPageValidated = false,
    this.page = RegisterPage.first,
    this.message = '',
  });

  final FullName fullName;

  final Email email;

  final Password password;

  final ConfirmPassword confirmPassword;

  final FormzSubmissionStatus status;

  final bool isFirstPageValidated;

  final bool isSecondPageValidated;

  final RegisterPage page;

  final String message;

  RegisterState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isFirstPageValidated,
    bool? isSecondPageValidated,
    RegisterPage? page,
    String? message,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isFirstPageValidated: isFirstPageValidated ?? this.isFirstPageValidated,
      isSecondPageValidated:
          isSecondPageValidated ?? this.isSecondPageValidated,
      page: page ?? this.page,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        status,
        isFirstPageValidated,
        isSecondPageValidated,
        page,
        message,
      ];
}
