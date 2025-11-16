import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/implementations/file_picker_service.dart';

void main() {
  group('FilePickerService', () {
    late FilePickerService fileService;

    setUp(() {
      fileService = FilePickerService();
    });

    test('getFileName extracts file name from path', () {
      expect(fileService.getFileName('/path/to/file.txt'), 'file.txt');
      expect(fileService.getFileName('C:\\Users\\Documents\\file.txt'), 'file.txt');
      expect(fileService.getFileName('file.txt'), 'file.txt');
    });

    test('getFileExtension extracts extension from path', () {
      expect(fileService.getFileExtension('/path/to/file.txt'), 'txt');
      expect(fileService.getFileExtension('/path/to/file.tar.gz'), 'gz');
      expect(fileService.getFileExtension('/path/to/file'), '');
    });

    test('getFileName handles paths with multiple separators', () {
      expect(fileService.getFileName('/path/to/some/file.pdf'), 'file.pdf');
      expect(fileService.getFileName('C:\\Users\\name\\Documents\\report.docx'), 'report.docx');
    });

    test('getFileExtension handles files without extension', () {
      expect(fileService.getFileExtension('/path/to/README'), '');
      expect(fileService.getFileExtension('Makefile'), '');
    });

    // Note: File system operations and file picker dialogs require platform integration
    // and are difficult to test in unit tests. These would be better tested with
    // integration tests or by mocking the FilePicker.platform methods.
  });
}
