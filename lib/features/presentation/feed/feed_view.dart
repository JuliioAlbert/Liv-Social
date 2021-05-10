import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/presentation/common/spin_loading_indicator.dart';
import 'package:liv_social/features/presentation/feed/feed_cubit.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedCubit(context.read())..getFeedActivities(),
      child: const FeedView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FeedCubit>();
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        if (state is FeedInitialState) {
          return const Center(child: SpinLoadingIndicator());
        } else {
          return ListView(
            children: bloc.activities != null && bloc.activities!.isNotEmpty
                ? bloc.activities!
                    .map((activity) => _ActivityCard(activity: activity))
                    .toList()
                : [],
          );
        }
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        return Container(
          width: size.width * .7,
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: size.width * .08),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
                colors: [
                  Color(0xff020024),
                  Color(0xff090979),
                  Color(0xff00d4ff),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .65, 1]),
            image: activity.image != null
                ? DecorationImage(
                    image: NetworkImage(activity.image!), fit: BoxFit.contain)
                : null,
          ),
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
