part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValidated = false,
    this.message = '',
  });

  final Email email;

  final Password password;

  final FormzSubmissionStatus status;

  final bool isValidated;

  final String message;

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValidated,
    String? message,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValidated: isValidated ?? this.isValidated,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        email,
        password,
        status,
        isValidated,
        message,
      ];
}
