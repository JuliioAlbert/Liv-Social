import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/data/repositories/remote/account_repository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/auth_repository_impl.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/logout_usecase.dart';

class DependencyInjection {
  const DependencyInjection._();

  static List<RepositoryProvider> build() {
    return [
      RepositoryProvider<AuthRepository>(
        create: (_) => AuthRepositoryImpl(),
      ),
      RepositoryProvider<AccountRepository>(
        create: (_) => AccountRepositoryImpl(),
      ),
      RepositoryProvider<LogOutUseCase>(
        create: (context) => LogOutUseCase(
          context.read(),
        ),
      ),
      RepositoryProvider<LoginUseCase>(
        create: (context) => LoginUseCase(
          context.read(),
          context.read(),
        ),
      ),
    ];
  }
}
