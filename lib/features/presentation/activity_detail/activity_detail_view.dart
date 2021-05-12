import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/core/extension/date_extension.dart';
import 'package:liv_social/core/extension/string_extension.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/core/theme/pallete_color.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/presentation/activity_detail/activity_detail_cubit.dart';
import 'package:liv_social/features/presentation/activity_update/activity_update_view.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';

class ActivityDetailViewArgs {
  final Activity activity;
  final HomeCubit homeCubit;

  ActivityDetailViewArgs(
    this.activity,
    this.homeCubit,
  );
}

class ActivityDetailView extends StatelessWidget {
  const ActivityDetailView({Key? key}) : super(key: key);

  static Widget create(BuildContext context, ActivityDetailViewArgs args) {
    return BlocProvider(
      create: (context) => ActivityDetailCubit(
        args.activity,
        context.read(),
        args.homeCubit,
      ),
      child: const ActivityDetailView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _ActivityDetailsBody(),
      ),
    );
  }
}

class _ActivityDetailsBody extends StatelessWidget {
  const _ActivityDetailsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityDetailCubit, ActivityDetailState>(
        builder: (context, state) => Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff833ab4),
                    Color(0xfffd1d1d),
                    Color(0xfffcb045),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, .35, 1],
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: _ActivityCard(),
                  ),
                ],
              ),
            ));
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivityDetailCubit>();
    final activity = bloc.activity;
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ActivityDetailCubit, ActivityDetailState>(
      builder: (context, state) {
        return Container(
          width: size.width * .7,
          height: size.height * .7,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
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
              stops: [0, .65, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.6),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
            image: activity.image != null
                ? DecorationImage(
                    image: NetworkImage(activity.image!), fit: BoxFit.contain)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _WhenField(
                dateString: activity.expectedDate!.formatyyyyMMddHHmm(),
              ),
              _ActivityField(
                fontSize: 30.0,
                value: activity.title,
              ),
              _ActivityField(
                fontSize: 20.0,
                value: activity.subtitle,
              ),
              _ActivityField(
                fontSize: 15.0,
                value: activity.details,
              ),
              _LocationField(address: activity.locationPlace.address),
              _ActivityField(
                fontSize: 10.0,
                value: 'Created By: ${activity.ownerName}', // TODO : translate
              ),
              Visibility(
                visible: bloc.isOwner,
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * .1),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          color: PalleteColor.actionButtonColor),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(Routes.activityUpdate,
                              arguments: ActivityUpdateViewArgs(activity))
                          .then((response) => bloc.processUpdate(response)),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

typedef TextCallback = Function(String text);

class _ActivityField extends StatelessWidget {
  const _ActivityField({
    Key? key,
    required this.value,
    required this.fontSize,
  }) : super(key: key);

  final String value;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.5),
              spreadRadius: 1,
              blurRadius: 5),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text(value,
          maxLines: 3,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: fontSize)),
    );
  }
}

class _WhenField extends StatelessWidget {
  const _WhenField({
    Key? key,
    required this.dateString,
  }) : super(key: key);
  final String dateString;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              '${Keys.when.localize()}:',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.transparent,
              child: Text(
                '$dateString',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    Key? key,
    required this.address,
  }) : super(key: key);
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${Keys.where.localize()}:',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      '$address',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.location_on,
                    color: PalleteColor.actionButtonColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
