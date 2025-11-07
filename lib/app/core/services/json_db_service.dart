import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env.dart';

/// Local JSON database service
/// Reads/writes JSON files in app documents directory
/// Seeds from assets on first run
/// Simulates network latency and errors for realism
class JsonDbService extends GetxService {
  late Directory _dbDir;
  final Random _random = Random();

  /// Initialize the service
  Future<JsonDbService> init() async {
    // Get app documents directory
    final docDir = await getApplicationDocumentsDirectory();
    _dbDir = Directory('${docDir.path}/db');

    // Create db directory if it doesn't exist
    if (!await _dbDir.exists()) {
      await _dbDir.create(recursive: true);
    }

    // Seed from assets if needed
    await _seedFromAssets();

    print('[JsonDbService] Initialized at ${_dbDir.path}');
    return this;
  }

  /// Seed database from assets if files don't exist
  Future<void> _seedFromAssets() async {
    final seedFiles = [
      'brands.json',
      'models.json',
      'vendors.json',
      'customers.json',
      'product_units.json',
      'purchases.json',
      'sales.json',
      'meta.json',
    ];

    for (final fileName in seedFiles) {
      final file = File('${_dbDir.path}/$fileName');
      if (!await file.exists()) {
        try {
          final assetData = await rootBundle.loadString('assets/db_seed/$fileName');
          await file.writeAsString(assetData);
          print('[JsonDbService] Seeded $fileName from assets');
        } catch (e) {
          // If asset doesn't exist, create empty array
          await file.writeAsString('[]');
          print('[JsonDbService] Created empty $fileName');
        }
      }
    }
  }

  /// Read a JSON file as a list
  Future<List<dynamic>> readList(String name) async {
    await _simulateLatency();
    await _simulateFault();

    final file = File('${_dbDir.path}/$name.json');
    if (!await file.exists()) {
      return [];
    }

    final content = await file.readAsString();
    final data = jsonDecode(content);
    
    if (data is List) {
      return data;
    }
    
    throw Exception('Expected list in $name.json but got ${data.runtimeType}');
  }

  /// Write a list to a JSON file
  Future<void> writeList(String name, List<dynamic> data) async {
    await _simulateLatency();
    await _simulateFault();

    final file = File('${_dbDir.path}/$name.json');
    final content = jsonEncode(data);
    await file.writeAsString(content);
  }

  /// Read a JSON file as a map
  Future<Map<String, dynamic>> readMap(String name) async {
    await _simulateLatency();
    await _simulateFault();

    final file = File('${_dbDir.path}/$name.json');
    if (!await file.exists()) {
      return {};
    }

    final content = await file.readAsString();
    final data = jsonDecode(content);
    
    if (data is Map<String, dynamic>) {
      return data;
    }
    
    throw Exception('Expected map in $name.json but got ${data.runtimeType}');
  }

  /// Write a map to a JSON file
  Future<void> writeMap(String name, Map<String, dynamic> data) async {
    await _simulateLatency();
    await _simulateFault();

    final file = File('${_dbDir.path}/$name.json');
    final content = jsonEncode(data);
    await file.writeAsString(content);
  }

  /// Simulate network latency
  Future<void> _simulateLatency() async {
    if (AppEnv.current.latencyMs > 0) {
      await Future.delayed(Duration(milliseconds: AppEnv.current.latencyMs));
    }
  }

  /// Simulate random faults for testing error handling
  Future<void> _simulateFault() async {
    if (AppEnv.current.faultRate > 0 && _random.nextDouble() < AppEnv.current.faultRate) {
      throw Exception('Simulated network error');
    }
  }

  /// Clear all data (for testing)
  Future<void> clearAll() async {
    if (_dbDir.existsSync()) {
      await _dbDir.delete(recursive: true);
      await _dbDir.create(recursive: true);
      await _seedFromAssets();
    }
  }
}
