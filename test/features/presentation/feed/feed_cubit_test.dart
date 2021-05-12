import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';
import 'package:liv_social/features/domain/repositories/cloud_storage_repository.dart';
import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:liv_social/features/domain/usecases/get_activities_usecase.dart';
import 'package:liv_social/features/domain/usecases/logout_usecase.dart';
import 'package:liv_social/features/presentation/feed/feed_cubit.dart';
import 'package:liv_social/features/presentation/home/home_cubit.dart';
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
  group('FeedCubit', () {
    late ActivityRepository activityRepository;
    late AuthRepository authRepository;
    late GetActiviesUseCase getActiviesUseCase;
    late LogOutUseCase logOutUseCase;
    final fileFake = File('path');
    late Activity activityFake1;
    late Activity activityFake2;
    late HomeCubit homeCubit;

    setUpAll(() {
      registerFallbackValue<Activity>(FakeActivity());
    });

    setUp(() {
      activityRepository = MockActivityRepository();
      authRepository = MockAuthRepository();
      getActiviesUseCase = GetActiviesUseCase(activityRepository);
      activityFake1 =
          Activity.fromJson(jsonDecode(source('activity_sample.json')));
      activityFake2 =
          Activity.fromJson(jsonDecode(source('activity_2_sample.json')));
      logOutUseCase = LogOutUseCase(authRepository);
      homeCubit = HomeCubit(logOutUseCase);
    });

    test('initial state is ', () {
      final activityCreateCubit = FeedCubit(homeCubit, getActiviesUseCase);
      expect(activityCreateCubit.state, FeedInitialState());
      activityCreateCubit.close();
    });

    group('getFeedActivities', () {
      setUp(() {
        when(() => activityRepository.getActivities())
            .thenAnswer((_) => Future.value([activityFake1, activityFake2]));
      });
      blocTest<FeedCubit, FeedState>(
        'invokes getActivities on activityRepository',
        build: () => FeedCubit(homeCubit, getActiviesUseCase),
        act: (cubit) => cubit.getFeedActivities(),
        verify: (_) {
          verify(() => activityRepository.getActivities()).called(1);
        },
      );

      blocTest<FeedCubit, FeedState>(
        'get Activities success',
        build: () => FeedCubit(homeCubit, getActiviesUseCase),
        act: (cubit) => cubit.getFeedActivities(),
        expect: () => <FeedState>[
          FeedActivitiesLoadedState([activityFake1, activityFake2]),
        ],
      );

      blocTest<FeedCubit, FeedState>(
        'get Activities and throws Exception',
        build: () {
          when(() => activityRepository.getActivities())
              .thenThrow(GetActivitiesFailure());
          return FeedCubit(homeCubit, getActiviesUseCase);
        },
        act: (cubit) => cubit.getFeedActivities(),
        expect: () => <FeedState>[
          FeedActivitiesErrorState(),
        ],
      );
    });
  });
}
