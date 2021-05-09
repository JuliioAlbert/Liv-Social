import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_social/features/presentation/activity_detail/activity_detail_view.dart';
import 'package:liv_social/features/presentation/activity_form/activity_form_view.dart';
import 'package:liv_social/features/presentation/home/home_view.dart';
import 'package:liv_social/features/presentation/login/login_view.dart';
import 'package:liv_social/features/presentation/splash/splash_view.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const activityDetail = '/activityDetail';
  static const activityForm = '/activityForm';

  static Route routes(RouteSettings routeSettings) {
    print('Route name: ${routeSettings.name}');
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case splash:
        return _buildRoute(SplashView.create);
      case login:
        return _buildRoute(LoginView.create);
      case home:
        return _buildRoute(HomeView.create);
      case activityDetail:
        return _buildRoute(ActivityDetailView.create, args);
      case activityForm:
        return _buildRoute(ActivityFormView.create);
      default:
        throw PlatformException(
            code: 'ROUTE_ERROR', message: 'Route does not exist');
    }
  }

  static PageRouteBuilder _buildRoute(Function buildFunction, [Object? args]) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) =>
          args != null ? buildFunction(context, args) : buildFunction(context),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
