import 'dart:io';

import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/usecases/upload_storage_usecase.dart';

class UpdateActivityUseCase {
  UpdateActivityUseCase(
    this._activityRepository,
    this._uploadStorageUseCase,
  );

  final ActivityRepository _activityRepository;
  final UploadStorageUseCase _uploadStorageUseCase;

  Future<bool> updateActivity(Activity activity, File? image) async {
    try {
      if (image != null) {
        final urlDownload =
            await _uploadStorageUseCase.uploadFile(image, activity.uid!);
        activity.image = urlDownload;
      }
      return await _activityRepository.updateActivity(activity);
    } catch (e) {
      throw UpdateActivityFailure();
    }
  }
}
