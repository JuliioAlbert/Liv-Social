import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liv_social/features/presentation/activity_detail/activity_detail_view.dart';
import 'package:liv_social/features/presentation/activity_create/activity_create_view.dart';
import 'package:liv_social/features/presentation/activity_update/activity_update_view.dart';
import 'package:liv_social/features/presentation/home/home_view.dart';
import 'package:liv_social/features/presentation/location/location_view.dart';
import 'package:liv_social/features/presentation/login/login_view.dart';
import 'package:liv_social/features/presentation/splash/splash_view.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const activityCreate = '/activityForm';
  static const activityDetail = '/activityDetail';
  static const activityUpdate = '/activityUpdate';
  static const location = '/location';

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
      case activityCreate:
        return _buildRoute(ActivityCreateView.create);
      case activityDetail:
        return _buildRoute(ActivityDetailView.create, args);
      case activityUpdate:
        return _buildRoute(ActivityUpdateView.create, args);
      case location:
        return _buildRoute(LocationView.create);
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
