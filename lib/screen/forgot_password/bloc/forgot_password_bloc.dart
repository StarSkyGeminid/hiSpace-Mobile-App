import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/formz_models/email.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._authenticationRepository)
      : super(const ForgotPasswordState()) {
    on<ForgotPasswordOnEmailChanged>(_onEmailChanged);
    on<ForgotPasswordOnSubmitted>(_onSubmitted);
    on<ForgotPasswordEvent>((event, emit) {});
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onEmailChanged(ForgotPasswordOnEmailChanged event,
      Emitter<ForgotPasswordState> emit) async {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: FormzSubmissionStatus.initial,
      isValidated: Formz.validate([email]),
    ));
  }

  Future<void> _onSubmitted(ForgotPasswordOnSubmitted event,
      Emitter<ForgotPasswordState> emit) async {
    if (!state.isValidated) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      bool status = await _authenticationRepository.resetPassword(
          email: state.email.value);

      emit(state.copyWith(
        status: status
            ? FormzSubmissionStatus.success
            : FormzSubmissionStatus.failure,
        message: status ? 'Periksa email Anda' : 'Email yang Anda masukkan tidak terdaftar',
      ));
    } on EmailDoesNotExist catch (_) {
      emit(
        state.copyWith(
            status: FormzSubmissionStatus.failure,
            message: 'Email yang Anda masukkan tidak terdaftar'),
      );
    } on RequestFailure catch (_) {
      emit(
        state.copyWith(
            status: FormzSubmissionStatus.failure,
            message: 'Email yang Anda masukkan tidak terdaftar'),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: FormzSubmissionStatus.failure,
            message: 'Terjadi kesalahan, silahkan coba lagi'),
      );
    }
  }
}
