import 'dart:io';

abstract class CloudStorageRepository {
  Future<String> uploadFile(File file, String path);
}
