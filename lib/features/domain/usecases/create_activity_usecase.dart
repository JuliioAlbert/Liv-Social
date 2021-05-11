import 'dart:io';

import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/usecases/upload_storage_usecase.dart';
import 'package:uuid/uuid.dart';

class CreateActivityUseCase {
  CreateActivityUseCase(
    this._activityRepository,
    this._uploadStorageUseCase,
  );
  final ActivityRepository _activityRepository;
  final UploadStorageUseCase _uploadStorageUseCase;
  final uuid = const Uuid();

  Future<Activity> createActivity(Activity activity, File? image) async {
    try {
      activity.uid = uuid.v4();
      if (image != null) {
        final urlDownload =
            await _uploadStorageUseCase.uploadFile(image, activity.uid!);
        activity.image = urlDownload;
      }
      return await _activityRepository.createActivity(activity);
    } catch (e) {
      throw CreateActivityFailure();
    }
  }
}
