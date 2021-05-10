import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/core/localization/keys.dart';
import 'package:liv_social/core/navigation/routes.dart';
import 'package:liv_social/core/theme/app_theme.dart';
import 'package:liv_social/core/theme/pallete_color.dart';
import 'package:liv_social/features/presentation/common/bottom_bar_app.dart';
import 'package:liv_social/features/presentation/common/dialogs.dart';
import 'package:liv_social/features/presentation/common/multiple_fab.dart';
import 'package:liv_social/core/theme/theme_cubit.dart';
import 'package:liv_social/features/presentation/feed/feed_view.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';
import 'package:liv_social/features/presentation/profile/profile_view.dart';
import 'package:liv_social/core/extension/string_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(context.read()),
      child: const HomeView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeBloc = context.watch<ThemeCubit>();
    final isLight = themeBloc.state.appThemeType == AppTheme.Light;
    final homeBloc = context.read<HomeCubit>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor:
            isLight ? Colors.white : theme.bottomAppBarColor,
        systemNavigationBarIconBrightness:
            isLight ? Brightness.dark : Brightness.light,
        statusBarColor: isLight ? Colors.white : theme.primaryColor,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
      ),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            await confirmation(
              context,
              Keys.logout_question.localize(),
              '',
              Keys.cancel.localize(),
              Keys.yes.localize(),
              () => homeBloc.logout(),
            );
            return false;
          },
          child: Scaffold(
            backgroundColor: theme.backgroundColor,
            body: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeLogoutState) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.login, (route) => false);
                }
              },
              builder: (BuildContext context, HomeState state) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  fit: StackFit.expand,
                  children: [
                    IndexedStack(
                      index: state.page.index,
                      children: [
                        FeedView.create(context),
                        ProfileView.create(context),
                      ],
                    ),
                    const Positioned(
                        bottom: 4.0, child: _FloatingActionButtonCustom()),
                  ],
                );
              },
            ),
            extendBody: true,
            floatingActionButton: IgnorePointer(
                child: SizedBox(
              width: 50.0,
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 0,
                heroTag: null,
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
            )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: const _BottomBarCustom(),
          ),
        ),
      ),
    );
  }
}

class _BottomBarCustom extends StatelessWidget {
  const _BottomBarCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeBloc = context.read<HomeCubit>();
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: PalleteColor.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(5.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 65, width: 85.0),
            Expanded(
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: PalleteColor.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(5.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<HomeCubit, HomeState>(
            builder: (BuildContext context, HomeState state) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            child: BottomBarApp(
              onTabSelected: (index) =>
                  homeBloc.changePage(IndexPage.values[index]),
              selectedIndex: homeBloc.state.page.index,
              notchedShape: const CircularNotchedRectangle(),
              backgroundColor: theme.bottomAppBarColor,
              color: const Color(0xffCFD7ED),
              selectedColor: PalleteColor.actionButtonColor,
              height: 65.0,
              items: [
                const BottomBarAppItem(icon: 'assets/icons/home/feed.svg'),
                const BottomBarAppItem(icon: 'assets/icons/home/profile.svg'),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _FloatingActionButtonCustom extends StatefulWidget {
  const _FloatingActionButtonCustom({
    Key? key,
  }) : super(key: key);

  @override
  __FloatingActionButtonCustomState createState() =>
      __FloatingActionButtonCustomState();
}

class __FloatingActionButtonCustomState
    extends State<_FloatingActionButtonCustom>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration duration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<HomeCubit>();
    return MultipleFAB(
      controller: _controller,
      backgroundColor: PalleteColor.actionButtonColor,
      actionButtons: [
        () => Navigator.of(context)
            .pushNamed(Routes.activityForm)
            .then((value) => bloc.reloadFeed()),
        () {}
      ],
      icons: [
        Tooltip(
          message: Keys.create_activity.localize(),
          child: const Icon(Icons.create_new_folder,
              color: Colors.white, size: 25),
        ),
        const Tooltip(
          message: 'Button 2', // TODO: set option helper
          child: Icon(Icons.more_horiz_outlined, color: Colors.white, size: 25),
        ),
      ],
    );
  }
}
