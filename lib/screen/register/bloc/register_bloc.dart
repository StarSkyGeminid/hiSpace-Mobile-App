import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/formz_models/confirm_password.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';
import 'package:hispace_mobile_app/formz_models/models.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authenticationRepository) : super(const RegisterState()) {
    on<RegisterOnFullNameChanged>(_onFullNameChanged);
    on<RegisterOnEmailChanged>(_onEmailChanged);
    on<RegisterOnPasswordChanged>(_onPasswordChanged);
    on<RegisterOnConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterPageChanged>(_onPageChanged);
    on<RegisterOnSubmitted>(_onPageSubmitted);
    on<RegisterEvent>((event, emit) {});
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onFullNameChanged(
      RegisterOnFullNameChanged event, Emitter<RegisterState> emit) async {
    final fullName = FullName.dirty(event.fullName);
    emit(state.copyWith(
      fullName: fullName,
      isFirstPageValidated: Formz.validate([
        fullName,
        state.email,
      ]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onEmailChanged(
      RegisterOnEmailChanged event, Emitter<RegisterState> emit) async {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isFirstPageValidated: Formz.validate([
        state.fullName,
        email,
      ]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onPasswordChanged(
      RegisterOnPasswordChanged event, Emitter<RegisterState> emit) async {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isSecondPageValidated: Formz.validate([
        password,
        state.confirmPassword,
      ]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onConfirmPasswordChanged(RegisterOnConfirmPasswordChanged event,
      Emitter<RegisterState> emit) async {
    final confirmPassword = ConfirmPassword.dirty(
        password: state.password.value, value: event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isSecondPageValidated: Formz.validate([
        state.password,
        confirmPassword,
      ]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  Future<void> _onPageChanged(
      RegisterPageChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(page: event.page));
  }

  Future<void> _onPageSubmitted(
      RegisterOnSubmitted event, Emitter<RegisterState> emit) async {
    if (state.page == RegisterPage.first) {
      emit(state.copyWith(page: RegisterPage.second));
      return;
    }

    if (!state.isFirstPageValidated || !state.isSecondPageValidated) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      var model = RegisterModel(
          fullName: state.fullName.value,
          email: state.email.value,
          password: state.password.value);

      await _authenticationRepository.register(registerModel: model);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on EmailAlreadyExists {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          message: 'Email sudah terdaftar'));
    } catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          message: 'Terjadi kesalahan ketika mendaftar'));
    }
  }
}
