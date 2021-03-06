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
import 'package:liv_social/features/presentation/activity_create/activity_create_cubit.dart';
import 'package:liv_social/features/presentation/common/dialogs.dart';

class ActivityCreateView extends StatelessWidget {
  const ActivityCreateView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCreateCubit(
        context.read(),
        context.read(),
        context.read(),
      ),
      child: const ActivityCreateView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _ActivityCreateBody(),
      ),
    );
  }
}

class _ActivityCreateBody extends StatelessWidget {
  const _ActivityCreateBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivityCreateCubit>();
    return BlocListener<ActivityCreateCubit, ActivityCreateState>(
        listener: (context, state) {
          if (state is ActivityCreateExitRequestState) {
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
          } else if (state is ActivityCreateShowLoadingState) {
            loading(context, Keys.loading.localize());
          } else if (state is ActivityCreateHideLoadingState) {
            Navigator.of(context).pop();
          } else if (state is ActivityCreateRegisterSuccessState) {
            Navigator.of(context).pop(true);
          } else if (state is ActivityCreateFillFieldsSuccessState) {
            alertMessage(context, 'Complete', 'You must complete all fields');
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
                const _FormCard(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () => bloc.createActivity(),
                      child: Text(Keys.create_activity.localize())),
                ),
              ],
            ),
          ),
        ));
  }
}

class _FormCard extends HookWidget {
  const _FormCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final subtitleController = useTextEditingController();
    final detailsController = useTextEditingController();
    final bloc = context.watch<ActivityCreateCubit>();
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ActivityCreateCubit, ActivityCreateState>(
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
                : null,
          ),
          child: Column(
            children: [
              const _WhenField(),
              _TextFieldCustom(
                controller: titleController,
                fontSize: 30.0,
                hinText: 'What do you do? - Tap to change',
                onChanged: (text) => bloc.title = text,
              ),
              _TextFieldCustom(
                controller: subtitleController,
                fontSize: 20.0,
                hinText: 'Subtitle - Tap to change',
                onChanged: (text) => bloc.subtitle = text,
              ),
              _TextFieldCustom(
                controller: detailsController,
                fontSize: 15.0,
                hinText: 'Details - Tap to change',
                onChanged: (text) => bloc.details = text,
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
    final bloc = context.watch<ActivityCreateCubit>();
    return BlocBuilder<ActivityCreateCubit, ActivityCreateState>(
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
                        '${bloc.expectedDate != null ? bloc.expectedDate!.formatyyyyMMddHHmm() : Keys.without_date.localize()}',
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
    final bloc = context.watch<ActivityCreateCubit>();
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
                child: bloc.locationPlace != null
                    ? Column(
                        children: [
                          Text(
                            '${bloc.locationPlace!.address}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : Text(
                        Keys.select_a_location.localize(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
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
