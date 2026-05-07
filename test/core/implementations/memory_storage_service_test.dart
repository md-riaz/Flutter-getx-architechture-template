import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/implementations/memory_storage_service.dart';

void main() {
  group('MemoryStorageService', () {
    late MemoryStorageService storage;

    setUp(() async {
      storage = MemoryStorageService();
      await storage.init();
    });

    test('init initializes the storage', () async {
      final newStorage = MemoryStorageService();
      await newStorage.init();
      expect(await newStorage.containsKey('test'), false);
    });

    test('setString and getString work correctly', () async {
      await storage.setString('key1', 'value1');
      final value = await storage.getString('key1');
      expect(value, 'value1');
    });

    test('setInt and getInt work correctly', () async {
      await storage.setInt('age', 25);
      final value = await storage.getInt('age');
      expect(value, 25);
    });

    test('setBool and getBool work correctly', () async {
      await storage.setBool('isActive', true);
      final value = await storage.getBool('isActive');
      expect(value, true);
    });

    test('setDouble and getDouble work correctly', () async {
      await storage.setDouble('price', 19.99);
      final value = await storage.getDouble('price');
      expect(value, 19.99);
    });

    test('setStringList and getStringList work correctly', () async {
      await storage.setStringList('tags', ['flutter', 'dart']);
      final value = await storage.getStringList('tags');
      expect(value, ['flutter', 'dart']);
    });

    test('remove deletes a key', () async {
      await storage.setString('key1', 'value1');
      await storage.remove('key1');
      final value = await storage.getString('key1');
      expect(value, null);
    });

    test('clear removes all keys', () async {
      await storage.setString('key1', 'value1');
      await storage.setInt('key2', 42);
      await storage.clear();
      
      expect(await storage.getString('key1'), null);
      expect(await storage.getInt('key2'), null);
      expect(await storage.getKeys(), isEmpty);
    });

    test('containsKey returns correct values', () async {
      await storage.setString('key1', 'value1');
      expect(await storage.containsKey('key1'), true);
      expect(await storage.containsKey('key2'), false);
    });

    test('getKeys returns all keys', () async {
      await storage.setString('key1', 'value1');
      await storage.setInt('key2', 42);
      final keys = await storage.getKeys();
      
      expect(keys.length, 2);
      expect(keys.contains('key1'), true);
      expect(keys.contains('key2'), true);
    });

    test('throws StateError if not initialized', () async {
      final newStorage = MemoryStorageService();
      expect(
        () => newStorage.setString('key', 'value'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
