import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/config/theme/color_pallete.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/formz_models/fullname.dart';
import 'package:hispace_mobile_app/widget/circular_profile_picture.dart';
import 'package:hispace_mobile_app/widget/custom_form.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';
import 'dart:math' as math;

import 'bloc/account_settings_bloc.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountSettingsBloc(
        RepositoryProvider.of<UserRepository>(context),
      )..add(const AccountSettingsOnInitial()),
      child: const AccountSettingsView(),
    );
  }
}

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => AccountSettingsViewState();
}

class AccountSettingsViewState extends State<AccountSettingsView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
      buildWhen: (previous, current) => previous.isChanged != current.isChanged,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            toolbarHeight: 80,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _ProfilePicture(size: size)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: kDefaultSpacing,
                    top: kDefaultSpacing * 2,
                    right: kDefaultSpacing,
                  ),
                  child: _NameForm(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: kDefaultSpacing,
                    top: kDefaultSpacing,
                    right: kDefaultSpacing,
                  ),
                  child: _EmailForm(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: state.isChanged ? const _SubmitButton() : null,
        );
      },
    );
  }
}

class _ProfilePicture extends StatefulWidget {
  const _ProfilePicture({
    required this.size,
  });

  final Size size;

  @override
  State<_ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<_ProfilePicture> {
  Uint8List? _bytes;

  Future<bool?> _imageSourceDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih sumber gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, true),
            ),
            ListTile(
              leading: const Icon(Icons.photo_rounded),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> _pickImage() async {
    bool? isCamera = await _imageSourceDialog();

    if (isCamera == null) return null;

    ImagePicker picker = ImagePicker();

    return await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
  }

  Future<void> _changeProfilePicture() async {
    var bloc = BlocProvider.of<AccountSettingsBloc>(context);

    XFile? image = await _pickImage();

    if (image == null) return;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Sesuaikan Foto',
          toolbarColor: const Color(0xFFFFFFFB),
          toolbarWidgetColor: ColorPallete.light.primary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Sesuaikan Foto',
        ),
      ],
    );

    if (croppedFile == null) return;
    bloc.add(AccountSettingsOnPhotoChanged(croppedFile));

    var bytes = await croppedFile.readAsBytes();

    setState(() {
      _bytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
            buildWhen: (previous, current) =>
                previous.image != current.image ||
                previous.isChanged != current.isChanged,
            builder: (context, state) {
              if (state.image == null || _bytes == null) {
                return const CircularProfilePicture();
              }

              return ClipOval(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(.2),
                  radius: math.min(widget.size.width / 4, 70),
                  child: Image.memory(_bytes!),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                Icons.camera_alt_outlined,
                size: math.min(widget.size.width / 4, 60),
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.2),
              ),
              onPressed: _changeProfilePicture,
            ),
          ),
        ),
      ],
    );
  }
}

class _NameForm extends StatelessWidget {
  const _NameForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
      builder: (context, state) {
        return CustomTextFormField(
          title: 'Nama',
          initialValue:
              BlocProvider.of<AuthenticationBloc>(context).state.user.fullName,
          onChanged: (value) => context
              .read<AccountSettingsBloc>()
              .add(AccountSettingsOnNameChanged(value)),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
            hintText: 'Masukkan Nama',
            errorText: state.fullName.displayError?.text(),
            errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                ),
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF969A9D),
                ),
          ),
        );
      },
    );
  }
}

class _EmailForm extends StatelessWidget {
  const _EmailForm();

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      title: 'Email',
      initialValue:
          BlocProvider.of<AuthenticationBloc>(context).state.user.email,
      enabled: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        hintText: 'Masukkan Email',
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
            ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF969A9D),
            ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultSpacing),
      child: BlocBuilder<AccountSettingsBloc, AccountSettingsState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isValidated != current.isValidated,
        builder: (context, state) {
          return ElevatedButton(
            key: const Key('AccountSettingsScreen_submitButton'),
            onPressed: state.isValidated && !state.status.isInProgress
                ? () {
                    BlocProvider.of<AccountSettingsBloc>(context)
                        .add(const AccountSettingsOnSubmitted());
                  }
                : null,
            child: state.status.isInProgress
                ? const Padding(
                    padding: EdgeInsets.all(kDefaultSpacing * .45),
                    child: CircularProgressIndicator.adaptive(),
                  )
                : const Padding(
                    padding: EdgeInsets.all(kDefaultSpacing * .8),
                    child: Text('Simpan'),
                  ),
          );
        },
      ),
    );
  }
}
