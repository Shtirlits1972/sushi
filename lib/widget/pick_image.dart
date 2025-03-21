import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<Uint8List?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return await pickedFile.readAsBytes();
  }
  return null;
}
