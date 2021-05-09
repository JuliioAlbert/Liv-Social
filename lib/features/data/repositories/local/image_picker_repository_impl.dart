import 'dart:io';

import 'package:liv_social/features/domain/repositories/image_picker_repository.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerRepositoryImpl extends ImagePickerRepository {
  @override
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 400);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
