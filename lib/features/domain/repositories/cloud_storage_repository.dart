import 'dart:io';

abstract class CloudStorageRepository {
  /// Upload a [File] to Cloud Storage. The `path` must be indicated to store
  Future<String> uploadFile(File file, String path);
}
