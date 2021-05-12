import 'dart:io';

abstract class ImagePickerRepository {
  /// Opens a wizard to select an image and returns the [File] of the selected image
  Future<File?> pickImage();
}
