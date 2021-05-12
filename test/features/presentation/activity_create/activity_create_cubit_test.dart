import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';
import 'package:liv_social/features/domain/repositories/cloud_storage_repository.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:liv_social/features/domain/usecases/create_activity_usecase.dart';
import 'package:liv_social/features/domain/usecases/login_usecase.dart';
import 'package:liv_social/features/domain/usecases/upload_storage_usecase.dart';
import 'package:liv_social/features/presentation/activity_create/activity_create_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockCloudStorageRepository extends Mock
    implements CloudStorageRepository {}

class MockImagePickerRepository extends Mock implements ImagePickerRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('SynonymsCubit', () {
    late ActivityRepository activityRepository;
    late CloudStorageRepository cloudStorageRepository;
    late ImagePickerRepository imagePickerRepository;
    late AuthRepository authRepository;
    late AccountRepository accountRepository;
    late UploadStorageUseCase uploadStorageUseCase;
    late CreateActivityUseCase createActivityUseCase;
    late LoginUseCase loginUseCase;

    setUp(() {
      activityRepository = MockActivityRepository();
      cloudStorageRepository = MockCloudStorageRepository();
      imagePickerRepository = MockImagePickerRepository();
      authRepository = MockAuthRepository();
      accountRepository = MockAccountRepository();
      uploadStorageUseCase = UploadStorageUseCase(cloudStorageRepository);
      createActivityUseCase =
          CreateActivityUseCase(activityRepository, uploadStorageUseCase);
      loginUseCase = LoginUseCase(authRepository, accountRepository);
    });

    test('initial state is ', () {
      final activityCreateCubit = ActivityCreateCubit(
          createActivityUseCase, loginUseCase, imagePickerRepository);
      expect(activityCreateCubit.state, ActivityCreateInitialState());
      activityCreateCubit.close();
    });
  });
}
