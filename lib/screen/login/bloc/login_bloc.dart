import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';
import 'package:hispace_mobile_app/formz_models/password.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authenticationRepository) : super(const LoginState()) {
    on<LoginOnEmailChanged>(_onEmailChanged);
    on<LoginOnPasswordChanged>(_onPasswordChanged);
    on<LoginOnSubmitted>(_onSubmitted);
    on<LoginEvent>((event, emit) {});
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onEmailChanged(
      LoginOnEmailChanged event, Emitter<LoginState> emit) async {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValidated: Formz.validate([email, state.password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onPasswordChanged(
      LoginOnPasswordChanged event, Emitter<LoginState> emit) async {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValidated: Formz.validate([state.email, password]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onSubmitted(
      LoginOnSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isValidated) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logIn(
          email: state.email.value, password: state.password.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on WrongPassword {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          message: 'Email atau password salah'));
    } on EmailDoesNotExist {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          message: 'Email atau password salah'));
    } catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          message: 'Terjadi kesalahan ketika login'));
    }
  }
}
