import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/formz_models/fullname.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:user_repository/user_repository.dart';

part 'account_settings_event.dart';
part 'account_settings_state.dart';

class AccountSettingsBloc
    extends Bloc<AccountSettingsEvent, AccountSettingsState> {
  AccountSettingsBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(const AccountSettingsState()) {
    on<AccountSettingsOnInitial>(_onInitial);
    on<AccountSettingsOnNameChanged>(_onNameChanged);
    on<AccountSettingsOnPhotoChanged>(_onPhotoChanged);
    on<AccountSettingsOnSubmitted>(_onSubmitted);
    on<AccountSettingsEvent>((event, emit) {});
  }

  final UserRepository _userRepository;

  Future<void> _onInitial(
    AccountSettingsOnInitial event,
    Emitter<AccountSettingsState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      User? user = await _userRepository.getUser();

      if (user == null) return;

      emit(state.copyWith(
        oldUser: user,
        fullName: FullName.dirty(user.fullName),
        isValidated: Formz.validate([FullName.dirty(user.fullName)]),
        status: FormzSubmissionStatus.initial,
      ));
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _onNameChanged(
    AccountSettingsOnNameChanged event,
    Emitter<AccountSettingsState> emit,
  ) {
    final name = FullName.dirty(event.name);

    emit(state.copyWith(
      isChanged: state.oldUser.fullName != name.value,
      fullName: name,
      isValidated: Formz.validate([name]),
      status: FormzSubmissionStatus.initial,
    ));
  }

  void _onPhotoChanged(
    AccountSettingsOnPhotoChanged event,
    Emitter<AccountSettingsState> emit,
  ) {
    emit(state.copyWith(
      status: FormzSubmissionStatus.initial,
      image: event.file,
      isValidated: Formz.validate([state.fullName]),
      isChanged: true,
    ));
  }

  Future<void> _onSubmitted(
    AccountSettingsOnSubmitted event,
    Emitter<AccountSettingsState> emit,
  ) async {
    if (!state.isValidated && !state.isChanged) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      Uint8List? imageBytes;

      if (state.image != null) {
        imageBytes = await state.image!.readAsBytes();
      }

      bool fullNameChanged = state.oldUser.fullName != state.fullName.value;

      _userRepository.updateUser(
        fullName: fullNameChanged ? state.fullName.value : null,
        imageBytes: imageBytes,
        fileName: imageBytes != null ? state.image!.path : null,
      );
      emit(state.copyWith(
          status: FormzSubmissionStatus.success, isChanged: false));
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
