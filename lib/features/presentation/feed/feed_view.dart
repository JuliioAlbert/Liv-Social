import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/core/navigation/routes.dart';

import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/presentation/activity_detail/activity_detail_view.dart';
import 'package:liv_social/features/presentation/common/spin_loading_indicator.dart';
import 'package:liv_social/features/presentation/feed/feed_cubit.dart';
import 'package:liv_social/core/extension/date_extension.dart';

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
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(Routes.activityDetail,
              arguments: ActivityDetailViewArgs(activity)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * .7,
              height: size.height * .4,
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: size.width * .08),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                    colors: [
                      Color(0xff833ab4),
                      Color(0xfffd1d1d),
                      Color(0xfffcb045),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, .35, 1]),
                image: activity.image != null
                    ? DecorationImage(
                        image: NetworkImage(activity.image!),
                        fit: BoxFit.contain)
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _FieldActivity(
                    value: activity.title,
                    spreadRadius: 5,
                    blurRadius: 10,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  _FieldActivity(
                    value: activity.subtitle,
                    spreadRadius: 0,
                    blurRadius: 5,
                    fontSize: 15,
                    color: Colors.transparent,
                  ),
                  _FieldActivity(
                    value: activity.expectedDate!.formatyyyyMMddHHmm(),
                    spreadRadius: 0,
                    blurRadius: 2,
                    fontSize: 10,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FieldActivity extends StatelessWidget {
  const _FieldActivity({
    Key? key,
    required this.value,
    required this.fontSize,
    required this.spreadRadius,
    required this.blurRadius,
    required this.color,
  }) : super(key: key);

  final String value;
  final double fontSize;
  final double spreadRadius;
  final double blurRadius;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: spreadRadius,
              blurRadius: blurRadius,
            )
          ]),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
