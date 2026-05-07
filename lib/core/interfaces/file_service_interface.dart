import 'dart:io';

/// Interface for file picking and saving operations
/// This allows swapping between different file picker implementations
/// (file_picker, image_picker, etc.) without changing usage
abstract class IFileService {
  /// Picks a single file. Returns the file path or null if cancelled.
  Future<String?> pickFile({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  });

  /// Picks multiple files. Returns list of file paths or empty list if cancelled.
  Future<List<String>> pickFiles({
    List<String>? allowedExtensions,
  });

  /// Picks a single image. Returns the file path or null if cancelled.
  Future<String?> pickImage({
    bool fromCamera = false,
  });

  /// Picks multiple images. Returns list of file paths or empty list if cancelled.
  Future<List<String>> pickImages();

  /// Picks a video file. Returns the file path or null if cancelled.
  Future<String?> pickVideo({
    bool fromCamera = false,
  });

  /// Picks a directory. Returns the directory path or null if cancelled.
  Future<String?> pickDirectory();

  /// Saves a file to device storage. Returns true if successful.
  Future<bool> saveFile({
    required String fileName,
    required List<int> bytes,
    String? dialogTitle,
  });

  /// Gets the file size in bytes
  Future<int> getFileSize(String filePath);

  /// Gets the file name from path
  String getFileName(String filePath);

  /// Gets the file extension from path
  String getFileExtension(String filePath);

  /// Checks if file exists
  Future<bool> fileExists(String filePath);

  /// Reads file as bytes
  Future<List<int>> readFileAsBytes(String filePath);

  /// Reads file as string
  Future<String> readFileAsString(String filePath);

  /// Deletes a file
  Future<bool> deleteFile(String filePath);
}
