import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/features/presentation/profile/profile_cubit.dart';

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
    return Container(
      child: ElevatedButton(
        onPressed: () => bloc.logout(),
        child: const Text('Logout'), // TODO: translate
      ),
    );
  }
}
