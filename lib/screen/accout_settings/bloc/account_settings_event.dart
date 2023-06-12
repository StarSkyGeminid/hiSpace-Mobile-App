part of 'account_settings_bloc.dart';

abstract class AccountSettingsEvent extends Equatable {
  const AccountSettingsEvent();

  @override
  List<Object> get props => [];
}

class AccountSettingsOnNameChanged extends AccountSettingsEvent {
  const AccountSettingsOnNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class AccountSettingsOnPhotoChanged extends AccountSettingsEvent {
  const AccountSettingsOnPhotoChanged(this.file);

  final CroppedFile file;

  @override
  List<Object> get props => [file];
}

class AccountSettingsOnSubmitted extends AccountSettingsEvent {
  const AccountSettingsOnSubmitted();
}

class AccountSettingsOnInitial extends AccountSettingsEvent {
  const AccountSettingsOnInitial();
}
