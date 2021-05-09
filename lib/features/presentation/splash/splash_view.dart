import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/features/presentation/common/spin_loading_indicator.dart';
import 'package:liv_social/features/presentation/splash/splash_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(context.read())..init(),
      child: const SplashView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, snapshot) {
        if (snapshot == SplashState.none) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        } else if (snapshot == SplashState.session_user) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.home, (route) => false);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const Center(
              child: SpinLoadingIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
