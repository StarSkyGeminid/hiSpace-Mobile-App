part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
