import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../interfaces/file_service_interface.dart';

/// Implementation of IFileService using file_picker package
/// This is a production-ready implementation that can handle various file operations
class FilePickerService implements IFileService {
  @override
  Future<String?> pickFile({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  @override
  Future<List<String>> pickFiles({
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error picking files: $e');
      return [];
    }
  }

  @override
  Future<String?> pickImage({bool fromCamera = false}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  @override
  Future<List<String>> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error picking images: $e');
      return [];
    }
  }

  @override
  Future<String?> pickVideo({bool fromCamera = false}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first.path;
      }
      return null;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  @override
  Future<String?> pickDirectory() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      return result;
    } catch (e) {
      print('Error picking directory: $e');
      return null;
    }
  }

  @override
  Future<bool> saveFile({
    required String fileName,
    required List<int> bytes,
    String? dialogTitle,
  }) async {
    try {
      final result = await FilePicker.platform.saveFile(
        fileName: fileName,
        bytes: bytes as Uint8List?,
        dialogTitle: dialogTitle,
      );

      return result != null;
    } catch (e) {
      print('Error saving file: $e');
      return false;
    }
  }

  @override
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  @override
  String getFileName(String filePath) {
    return filePath.split('/').last.split('\\').last;
  }

  @override
  String getFileExtension(String filePath) {
    final fileName = getFileName(filePath);
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : '';
  }

  @override
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  @override
  Future<List<int>> readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error reading file as bytes: $e');
      return [];
    }
  }

  @override
  Future<String> readFileAsString(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (e) {
      print('Error reading file as string: $e');
      return '';
    }
  }

  @override
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
