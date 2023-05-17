part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordOnEmailChanged extends ForgotPasswordEvent {
  const ForgotPasswordOnEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ForgotPasswordOnSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordOnSubmitted();
}
