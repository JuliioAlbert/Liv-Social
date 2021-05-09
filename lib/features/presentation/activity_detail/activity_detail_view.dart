import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/presentation/activity_detail/activity_detail_cubit.dart';

class ActivityDetailViewArgs {
  final Activity activity;

  ActivityDetailViewArgs(this.activity);
}

class ActivityDetailView extends StatelessWidget {
  const ActivityDetailView({Key? key}) : super(key: key);

  static Widget create(BuildContext context, ActivityDetailViewArgs args) {
    return BlocProvider(
      create: (context) => ActivityDetailCubit(
        context.read(),
        args.activity,
      ),
      child: const ActivityDetailView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: const Text('ActivityDetail'),
        ),
      ),
    );
  }
}
