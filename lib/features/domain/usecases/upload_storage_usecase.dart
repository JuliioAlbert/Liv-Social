import 'dart:io';

import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/domain/repositories/cloud_storage_repository.dart';

class UploadStorageUseCase {
  UploadStorageUseCase(this._cloudStorageRepository);
  final CloudStorageRepository _cloudStorageRepository;

  Future<String> uploadFile(File image, String uid) async {
    try {
      final urlDownload =
          await _cloudStorageRepository.uploadFile(image, 'activity/$uid');
      return urlDownload;
    } catch (e) {
      throw UpdateActivityFailure();
    }
  }
}
