import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:liv_social/core/theme/app_theme.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
            theme: appThemeData[AppTheme.Light]!,
            appThemeType: AppTheme.Light));

  void changeTheme(AppTheme appTheme) {
    emit(ThemeState(theme: appThemeData[appTheme]!, appThemeType: appTheme));
  }
}

class ThemeState extends Equatable {
  final ThemeData theme;
  final AppTheme appThemeType;

  const ThemeState({
    required this.theme,
    required this.appThemeType,
  });

  @override
  List<Object> get props => [theme, appThemeType];
}
