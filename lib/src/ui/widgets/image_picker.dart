import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickAndCropImage(Function(File?) onValue) {
  ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
    if (value != null) {
      ImageCropper.cropImage(
          sourcePath: value.path,
          maxWidth: 512,
          maxHeight: 512,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          cropStyle: CropStyle.circle).then((value) => onValue(value));
    }
  });
}