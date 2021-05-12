import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/utils/utils.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/presentation/location/widgets/network_image.dart';
import 'package:liv_social/features/presentation/profile/profile_cubit.dart';
import 'package:liv_social/core/extension/string_extension.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(context.read(), context.read<LoginUseCase>().user!),
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
          AvatarProfile(
            name: bloc.user.name,
            image: bloc.user.image,
          ),
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

class AvatarProfile extends StatelessWidget {
  const AvatarProfile({
    Key? key,
    this.image,
    required this.name,
    this.height = 100,
    this.enableBorder = false,
    this.nameBold = true,
    this.fontSize = 12.0,
    this.showName = true,
  }) : super(key: key);
  final String? image;
  final String name;
  final double height;
  final bool enableBorder;
  final bool nameBold;
  final double fontSize;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: enableBorder
                ? Border.all(color: Colors.black, width: 2.0)
                : null,
          ),
          child: ClipOval(
            child: Stack(
              children: [
                image != null && image!.isNotEmpty
                    ? PNetworkImage(
                        image!,
                        height: height,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.red,
                        height: height,
                        width: height,
                        alignment: Alignment.center,
                        child: Text(Utils.getNameInitials(name),
                            style: const TextStyle(
                                fontSize: 40.0, color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
        if (showName)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: nameBold ? FontWeight.w500 : FontWeight.normal),
            ),
          ),
      ],
    );
  }
}
