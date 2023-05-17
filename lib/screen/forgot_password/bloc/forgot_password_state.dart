part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValidated = false,
    this.message = '',
  });

  final Email email;

  final FormzSubmissionStatus status;

  final bool isValidated;

  final String message;

  ForgotPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    bool? isValidated,
    String? message,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      isValidated: isValidated ?? this.isValidated,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        email,
        status,
        isValidated,
        message,
      ];
}
