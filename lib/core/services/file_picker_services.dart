import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerServices {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      return image;
    } catch (e) {
      rethrow;
    }
  }

  Future<XFile?> takeImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      return image;
    } catch (e) {
      rethrow;
    }
  }

  Future<XFile?> pickFile() async {
    try {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (file != null && file.files.isNotEmpty) {
        return XFile(file.files.first.path!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
