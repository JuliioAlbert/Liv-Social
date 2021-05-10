import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/features/presentation/profile/profile_cubit.dart';
import 'package:liv_social/core/extension/string_extension.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(context.read()),
      child: const ProfileView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileCubit>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => changeLocale(context, 'es'),
            child: const Text('Español'),
          ),
          ElevatedButton(
            onPressed: () => changeLocale(context, 'en'),
            child: const Text('English'),
          ),
          ElevatedButton(
            onPressed: () => bloc.logout(),
            child: Text(Keys.logout.localize()),
          ),
        ],
      ),
    );
  }
}
