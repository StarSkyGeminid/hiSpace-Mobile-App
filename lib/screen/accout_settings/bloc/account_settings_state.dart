part of 'account_settings_bloc.dart';

class AccountSettingsState extends Equatable {
  const AccountSettingsState({
    this.fullName = const FullName.pure(),
    this.image,
    this.status = FormzSubmissionStatus.initial,
    this.isValidated = false,
    this.isChanged = false,
    this.oldUser = User.empty,
  });

  final User oldUser;

  final FormzSubmissionStatus status;

  final bool isValidated;

  final FullName fullName;

  final CroppedFile? image;

  final bool isChanged;

  AccountSettingsState copyWith({
    FullName? fullName,
    CroppedFile? image,
    FormzSubmissionStatus? status,
    bool? isValidated,
    bool? isChanged,
    User? oldUser,
  }) {
    return AccountSettingsState(
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      status: status ?? this.status,
      isValidated: isValidated ?? this.isValidated,
      isChanged: isChanged ?? this.isChanged,
      oldUser: oldUser ?? this.oldUser,
    );
  }

  @override
  List<Object> get props => [
        fullName,
        status,
        isValidated,
        isChanged,
        oldUser,
      ];
}
