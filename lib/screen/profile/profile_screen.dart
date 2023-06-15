import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hispace_mobile_app/bloc/authentication/authentication_bloc.dart';
import 'package:hispace_mobile_app/core/extension/string_extension.dart';

import 'package:hispace_mobile_app/core/global/constans.dart';
import 'package:hispace_mobile_app/screen/profile/model/profile_menu_model.dart';
import 'package:hispace_mobile_app/widget/circular_profile_picture.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Profil', style: Theme.of(context).textTheme.titleMedium),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
              child: Center(child: CircularProfilePicture())),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: kDefaultSpacing / 2, bottom: kDefaultSpacing),
                child: Text(
                    BlocProvider.of<AuthenticationBloc>(context)
                        .state
                        .user
                        .userName
                        .toTitleCase(),
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _ProfileMenu()),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kDefaultSpacing),
                child: Text(
                  'Versi $appVersion',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatefulWidget {
  const _ProfileMenu();

  @override
  State<_ProfileMenu> createState() => __ProfileMenuState();
}

class __ProfileMenuState extends State<_ProfileMenu> {
  void _requestLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Keluar', style: Theme.of(context).textTheme.titleMedium),
        content: Text('Apakah anda yakin ingin keluar?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: Theme.of(context).textTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
            },
            child:
                Text('Keluar', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listProfileMenu.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
          child: ListTile(
            leading: Container(
              margin: const EdgeInsets.only(left: kDefaultSpacing / 2),
              padding: const EdgeInsets.all(kDefaultSpacing / 2),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(.1),
                  shape: BoxShape.circle),
              child: Icon(
                listProfileMenu[index].icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              listProfileMenu[index].title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              if (index != listProfileMenu.length - 1) {
                Navigator.pushNamed(context, listProfileMenu[index].route);
              } else {
                _requestLogout();
              }
            },
          ),
        );
      },
    );
  }
}
