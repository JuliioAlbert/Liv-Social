import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:liv_social/core/extension/date_extension.dart';
import 'package:liv_social/core/extension/string_extension.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/core/theme/pallete_color.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/presentation/activity_update/activity_update_cubit.dart';
import 'package:liv_social/features/presentation/common/dialogs.dart';

class ActivityUpdateViewArgs {
  final Activity activity;

  ActivityUpdateViewArgs(this.activity);
}

class ActivityUpdateView extends StatelessWidget {
  const ActivityUpdateView({Key? key}) : super(key: key);

  static Widget create(BuildContext context, ActivityUpdateViewArgs args) {
    return BlocProvider(
      create: (context) => ActivityUpdateCubit(
        context.read(),
        context.read(),
        args.activity,
      ),
      child: const ActivityUpdateView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _ActivityUpdateBody(),
      ),
    );
  }
}

class _ActivityUpdateBody extends StatelessWidget {
  const _ActivityUpdateBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivityUpdateCubit>();
    return BlocListener<ActivityUpdateCubit, ActivityUpdateState>(
      listener: (context, state) {
        if (state is ActivityUpdateExitRequestState) {
          confirmation(
            context,
            Keys.leave.localize(),
            Keys.alert_lose_changes.localize(),
            Keys.cancel.localize(),
            Keys.accept.localize(),
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        } else if (state is ActivityUpdateShowLoadingState) {
          loading(context, Keys.loading.localize());
        } else if (state is ActivityUpdateHideLoadingState) {
          Navigator.of(context).pop();
        } else if (state is ActivityUpdateSuccessState) {
          Navigator.of(context).pop(state.activity);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bloc.exit();
          return false;
        },
        child: Container(
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
                stops: [0, .35, 1]),
          ),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => bloc.exit(),
                ),
              ),
              _ActivityCard(activity: bloc.activity),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () => bloc.updateActivity(),
                  child: const Text('Update Activity'), // TODO: translate
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends HookWidget {
  const _ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: activity.title);
    final subtitleController =
        useTextEditingController(text: activity.subtitle);
    final detailsController = useTextEditingController(text: activity.details);
    final bloc = context.watch<ActivityUpdateCubit>();
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ActivityUpdateCubit, ActivityUpdateState>(
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
              stops: [0, .65, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.6),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
            image: bloc.image != null
                ? DecorationImage(
                    image: FileImage(bloc.image!), fit: BoxFit.contain)
                : bloc.activity.image != null
                    ? DecorationImage(
                        image: NetworkImage(activity.image!),
                        fit: BoxFit.contain)
                    : null,
          ),
          child: Column(
            children: [
              const _WhenField(),
              _TextFieldCustom(
                controller: titleController,
                fontSize: 30.0,
                hinText: 'What do you do? - Tap to change',
                onChanged: (text) => bloc.activity.title = text,
              ),
              _TextFieldCustom(
                controller: subtitleController,
                fontSize: 20.0,
                hinText: 'Subtitle - Tap to change',
                onChanged: (text) => bloc.activity.subtitle = text,
              ),
              _TextFieldCustom(
                controller: detailsController,
                fontSize: 15.0,
                hinText: 'Details - Tap to change',
                onChanged: (text) => bloc.activity.details = text,
              ),
              const _LocationField(),
              CircleAvatar(
                  child: IconButton(
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () => bloc.pickImage())),
            ],
          ),
        );
      },
    );
  }
}

typedef TextCallback = Function(String text);

class _TextFieldCustom extends StatelessWidget {
  const _TextFieldCustom({
    Key? key,
    required this.controller,
    required this.hinText,
    required this.onChanged,
    required this.fontSize,
  }) : super(key: key);

  final TextEditingController controller;
  final String hinText;
  final TextCallback onChanged;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              spreadRadius: 1,
              blurRadius: 5),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        decoration: InputDecoration.collapsed(
          hintText: hinText,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: fontSize),
      ),
    );
  }
}

class _WhenField extends StatelessWidget {
  const _WhenField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivityUpdateCubit>();
    return BlocBuilder<ActivityUpdateCubit, ActivityUpdateState>(
      builder: (context, state) {
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
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(
                        Icons.date_range,
                        color: PalleteColor.actionButtonColor,
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: bloc.now,
                          firstDate: bloc.now,
                          lastDate: bloc.lastDate,
                        );
                        final response = bloc.updateExpectedDate(date);
                        if (response) {
                          final time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          bloc.updateExpectedTime(time);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        '${bloc.activity.expectedDate != null ? bloc.activity.expectedDate!.formatyyyyMMddHHmm() : Keys.without_date.localize()}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivityUpdateCubit>();
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
                      '${bloc.activity.locationPlace.address}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.location_on,
                      color: PalleteColor.actionButtonColor,
                    ),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.location).then(
                    (place) {
                      if (place is Place?) {
                        bloc.updateLocationPlace(place);
                      }
                    },
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
