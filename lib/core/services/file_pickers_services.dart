import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickersServices {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      return image;
    }
    return null;
  }

  Future<XFile?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      return photo;
    }
    return null;
  }

  Future<XFile?> pickFile() async {
    final FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (file != null && file.files.isNotEmpty) {
      return XFile(file.files.first.path!);
    }
    return null;
  }
}
