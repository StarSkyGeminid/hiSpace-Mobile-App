import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class DoneFilling extends StatelessWidget {
  const DoneFilling({super.key, required this.isSuccess});

  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isSuccess ? const _SuccessUploading() : const _FailUploading(),
        bottomNavigationBar: _DoneButton(isSuccess),
      ),
    );
  }
}

class _FailUploading extends StatelessWidget {
  const _FailUploading();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(kDefaultSpacing),
      children: [
        const SizedBox(height: kDefaultSpacing),
        SvgPicture.asset(
          'assets/svg/undraw_server_down_s-4-lk.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Ups',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Terjadi kesalahan ketika mengupload data kafe kamu. Ulangi beberapa saat lagi atau hubungi admin.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
      ],
    );
  }
}

class _SuccessUploading extends StatelessWidget {
  const _SuccessUploading();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(kDefaultSpacing),
      children: [
        const SizedBox(height: kDefaultSpacing),
        SvgPicture.asset(
          'assets/svg/undraw_done_re_oak4.svg',
          width: size.width * 0.8,
          height: size.width * 0.5,
        ),
        const SizedBox(height: kDefaultSpacing),
        Text(
          'Selesai',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: kDefaultSpacing / 2),
        Text(
          'Selamat, data cafe kamu berhasil di upload.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kDefaultSpacing * 2),
      ],
    );
  }
}

class _DoneButton extends StatelessWidget {
  const _DoneButton(this.isSuccess);

  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing / 2),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: isSuccess
              ? const Padding(
                  padding: EdgeInsets.all(kDefaultSpacing * 0.8),
                  child: Text('Selesai'),
                )
              : const SizedBox(
                  height: kDefaultSpacing,
                  width: kDefaultSpacing,
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ),
    );
  }
}
