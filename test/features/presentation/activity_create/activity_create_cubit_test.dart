import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liv_social/features/data/models/place.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';
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

import '../../../sources/source_reader.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockCloudStorageRepository extends Mock
    implements CloudStorageRepository {}

class MockImagePickerRepository extends Mock implements ImagePickerRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class FakeActivity extends Fake implements Activity {}

class FakeFile extends Fake implements File {}

void main() {
  group('ActivityCubit', () {
    late ActivityRepository activityRepository;
    late CloudStorageRepository cloudStorageRepository;
    late ImagePickerRepository imagePickerRepository;
    late AuthRepository authRepository;
    late AccountRepository accountRepository;
    late UploadStorageUseCase uploadStorageUseCase;
    late CreateActivityUseCase createActivityUseCase;
    late LoginUseCase loginUseCase;
    final fileFake = File('path');
    final placeFake =
        Place('address', 'name', const LatLng(-12.9999, -77.0000));
    late Activity activityFake;

    setUpAll(() {
      registerFallbackValue<Activity>(FakeActivity());
      registerFallbackValue<File>(FakeFile());
    });

    setUp(() {
      activityRepository = MockActivityRepository();
      cloudStorageRepository = MockCloudStorageRepository();
      imagePickerRepository = MockImagePickerRepository();
      authRepository = MockAuthRepository();
      accountRepository = MockAccountRepository();
      uploadStorageUseCase = UploadStorageUseCase(cloudStorageRepository);
      activityFake =
          Activity.fromJson(jsonDecode(source('activity_sample.json')));
      createActivityUseCase =
          CreateActivityUseCase(activityRepository, uploadStorageUseCase);
      loginUseCase = LoginUseCase(authRepository, accountRepository);
      loginUseCase.user = UserModel(name: 'name', uid: 'uid', email: 'email');
    });

    test('initial state is ', () {
      final activityCreateCubit = ActivityCreateCubit(
          createActivityUseCase, loginUseCase, imagePickerRepository);
      expect(activityCreateCubit.state, ActivityCreateInitialState());
      activityCreateCubit.close();
    });

    group('pickImage', () {
      setUp(() {
        when(() => imagePickerRepository.pickImage())
            .thenAnswer((_) => Future.value(fileFake));
      });
      blocTest<ActivityCreateCubit, ActivityCreateState>(
        'invokes pickImage on imageRepository',
        build: () => ActivityCreateCubit(
            createActivityUseCase, loginUseCase, imagePickerRepository),
        act: (cubit) => cubit.pickImage(),
        verify: (_) {
          verify(() => imagePickerRepository.pickImage()).called(1);
        },
      );

      blocTest<ActivityCreateCubit, ActivityCreateState>(
        'emits ActivityCreateImageSelectedState when pickImage',
        build: () => ActivityCreateCubit(
            createActivityUseCase, loginUseCase, imagePickerRepository),
        act: (cubit) => cubit.pickImage(),
        expect: () => <ActivityCreateState>[
          ActivityCreateImageSelectedState(fileFake),
        ],
      );
    });

    group('updateLocation', () {
      blocTest<ActivityCreateCubit, ActivityCreateState>(
        'update location and emit ActivityCreatePlaceUpdateState',
        build: () => ActivityCreateCubit(
            createActivityUseCase, loginUseCase, imagePickerRepository),
        act: (cubit) => cubit.updateLocationPlace(placeFake),
        expect: () => <ActivityCreateState>[
          ActivityCreatePlaceUpdateState(
            LocationPlace(
                address: placeFake.address,
                latitude: placeFake.latLng.latitude,
                longitude: placeFake.latLng.longitude,
                name: placeFake.name),
          ),
        ],
      );
    });
    group('createActivity', () {
      setUp(() {});
      blocTest<ActivityCreateCubit, ActivityCreateState>(
        'create activity without image and emit success events',
        build: () {
          when(() => activityRepository.createActivity(any<Activity>()))
              .thenAnswer((_) => Future.value(activityFake));
          final activityCubit = ActivityCreateCubit(
              createActivityUseCase, loginUseCase, imagePickerRepository);
          activityCubit.title = activityFake.title;
          activityCubit.subtitle = activityFake.subtitle;
          activityCubit.details = activityFake.details;
          activityCubit.expectedDate = activityFake.expectedDate;
          activityCubit.locationPlace = activityFake.locationPlace;
          return activityCubit;
        },
        act: (cubit) => cubit.createActivity(),
        expect: () => <ActivityCreateState>[
          ActivityCreateShowLoadingState(),
          ActivityCreateHideLoadingState(),
          ActivityCreateRegisterSuccessState(),
        ],
      );

      blocTest<ActivityCreateCubit, ActivityCreateState>(
        'create activity  with image and emit success events',
        build: () {
          when(() => activityRepository.createActivity(any<Activity>()))
              .thenAnswer((_) => Future.value(activityFake));
          when(() =>
                  cloudStorageRepository.uploadFile(any<File>(), any<String>()))
              .thenAnswer((_) => Future.value('http://storage.com'));
          uploadStorageUseCase = UploadStorageUseCase(cloudStorageRepository);
          final activityCubit = ActivityCreateCubit(
              createActivityUseCase, loginUseCase, imagePickerRepository);
          activityCubit.title = activityFake.title;
          activityCubit.subtitle = activityFake.subtitle;
          activityCubit.details = activityFake.details;
          activityCubit.expectedDate = activityFake.expectedDate;
          activityCubit.locationPlace = activityFake.locationPlace;
          activityCubit.image = fileFake;
          return activityCubit;
        },
        act: (cubit) => cubit.createActivity(),
        expect: () => <ActivityCreateState>[
          ActivityCreateShowLoadingState(),
          ActivityCreateHideLoadingState(),
          ActivityCreateRegisterSuccessState(),
        ],
      );
    });
  });
}
