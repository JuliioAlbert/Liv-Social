import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:liv_social/app.dart';
import 'package:liv_social/core/di/dependency_injection.dart';
import 'package:liv_social/core/localization/localization_helper.dart';

import 'core/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final delegate = await LocalizationHelper.delegate;
  runApp(
    MultiRepositoryProvider(
      providers: DependencyInjection.build(),
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: LocalizedApp(delegate, const MyApp()),
      ),
    ),
  );
}
