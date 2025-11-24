import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class BeforeAfterStorageService {
  Future<String> saveLocalImage(
    XFile file,
    String sessionId,
    bool isBefore,
  ) async {
    final directory = await getApplicationDocumentsDirectory();

    final folder = Directory("${directory.path}/before_after/$sessionId");
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final filePath =
        "${folder.path}/${isBefore ? 'before' : 'after'}_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final savedFile = await File(file.path).copy(filePath);
    return savedFile.path;
  }
}
