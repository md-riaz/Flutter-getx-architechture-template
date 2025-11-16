import '../service_locator/service_locator.dart';
import '../interfaces/file_service_interface.dart';

/// File Facade - Laravel-style static access to file service
/// Usage: File.pick(); File.save('name.txt', bytes);
class Files {
  Files._(); // Private constructor to prevent instantiation

  static IFileService get _service => locator<IFileService>();

  /// Pick a single file
  static Future<String?> pick({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) {
    return _service.pickFile(
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );
  }

  /// Pick multiple files
  static Future<List<String>> pickMultiple({
    List<String>? allowedExtensions,
  }) {
    return _service.pickFiles(allowedExtensions: allowedExtensions);
  }

  /// Pick a single image
  static Future<String?> pickImage({bool fromCamera = false}) {
    return _service.pickImage(fromCamera: fromCamera);
  }

  /// Pick multiple images
  static Future<List<String>> pickImages() {
    return _service.pickImages();
  }

  /// Pick a video
  static Future<String?> pickVideo({bool fromCamera = false}) {
    return _service.pickVideo(fromCamera: fromCamera);
  }

  /// Pick a directory
  static Future<String?> pickDirectory() {
    return _service.pickDirectory();
  }

  /// Save a file
  static Future<bool> save({
    required String fileName,
    required List<int> bytes,
    String? dialogTitle,
  }) {
    return _service.saveFile(
      fileName: fileName,
      bytes: bytes,
      dialogTitle: dialogTitle,
    );
  }

  /// Get file size
  static Future<int> size(String filePath) {
    return _service.getFileSize(filePath);
  }

  /// Get file name
  static String name(String filePath) {
    return _service.getFileName(filePath);
  }

  /// Get file extension
  static String extension(String filePath) {
    return _service.getFileExtension(filePath);
  }

  /// Check if file exists
  static Future<bool> exists(String filePath) {
    return _service.fileExists(filePath);
  }

  /// Read file as bytes
  static Future<List<int>> readBytes(String filePath) {
    return _service.readFileAsBytes(filePath);
  }

  /// Read file as string
  static Future<String> readString(String filePath) {
    return _service.readFileAsString(filePath);
  }

  /// Delete a file
  static Future<bool> delete(String filePath) {
    return _service.deleteFile(filePath);
  }
}
