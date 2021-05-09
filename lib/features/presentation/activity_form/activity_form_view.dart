import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/features/presentation/activity_form/activity_form_cubit.dart';

class ActivityFormView extends StatelessWidget {
  const ActivityFormView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityFormCubit(
        context.read(),
        context.read(),
      ),
      child: const ActivityFormView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: const Text('ActivityForm'),
            ),
            ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.location),
                child: const Text('Location'))
          ],
        ),
      ),
    );
  }
}
