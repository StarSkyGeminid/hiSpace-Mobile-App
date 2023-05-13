part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginOnEmailChanged extends LoginEvent {
  const LoginOnEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginOnPasswordChanged extends LoginEvent {
  const LoginOnPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginOnSubmitted extends LoginEvent {
  const LoginOnSubmitted();
}
