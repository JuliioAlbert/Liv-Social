import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liv_social/features/data/datasource/firestore_database.dart';
import 'package:liv_social/features/data/datasource/google_maps_api_client.dart';
import 'package:liv_social/features/data/repositories/local/image_picker_repository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/account_repository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/activity_repository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/auth_repository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/cloud_storage_respository_impl.dart';
import 'package:liv_social/features/data/repositories/remote/location_repository_impl.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';
import 'package:liv_social/features/domain/repositories/cloud_storage_repository.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:liv_social/features/domain/repositories/location_repository.dart';
import 'package:liv_social/features/domain/usecases/get_activities_usecase.dart';
import 'package:liv_social/features/domain/usecases/get_location.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/logout_usecase.dart';
import 'package:liv_social/features/domain/usecases/manage_activity_usecase.dart';

class DependencyInjection {
  const DependencyInjection._();

  static List<RepositoryProvider> build() {
    final fireStoreDatabase = FirestoreDatabase();
    final googleMapsApiClient = GoogleMapsApiClient();

    return [
      RepositoryProvider<AuthRepository>(
        create: (_) => AuthRepositoryImpl(),
      ),
      RepositoryProvider<AccountRepository>(
        create: (_) => AccountRepositoryImpl(fireStoreDatabase),
      ),
      RepositoryProvider<ActivityRepository>(
        create: (_) => ActivityRepositoryImpl(fireStoreDatabase),
      ),
      RepositoryProvider<LocationRepository>(
        create: (_) => LocationRepositoryImpl(googleMapsApiClient),
      ),
      RepositoryProvider<ImagePickerRepository>(
        create: (_) => ImagePickerRepositoryImpl(),
      ),
      RepositoryProvider<CloudStorageRepository>(
        create: (_) => CloudStorageRepositoryImpl(),
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
      RepositoryProvider<GetActiviesUseCase>(
        create: (context) => GetActiviesUseCase(
          context.read(),
        ),
      ),
      RepositoryProvider<ManageActivityUseCase>(
        create: (context) => ManageActivityUseCase(
          context.read(),
        ),
      ),
      RepositoryProvider<GetLocationUseCase>(
        create: (context) => GetLocationUseCase(
          context.read(),
        ),
      ),
    ];
  }
}
