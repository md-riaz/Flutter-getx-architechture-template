import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'json_db_service.dart';

/// Service for generating sequential invoice numbers
/// Format: INV-yyyyMMdd-###
class NumberSeriesService extends GetxService {
  final JsonDbService _db = Get.find<JsonDbService>();

  /// Generate next number in series
  /// key: series identifier (e.g., 'invoice', 'purchase')
  /// prefix: optional prefix (e.g., 'INV', 'PUR')
  Future<String> next(String key, {String prefix = 'INV'}) async {
    // Read current series state
    final meta = await _db.readMap('meta');
    final series = meta['series'] as Map<String, dynamic>? ?? {};
    
    // Get today's date string
    final today = DateFormat('yyyyMMdd').format(DateTime.now());
    final seriesKey = '${key}_$today';
    
    // Get current counter for today
    int counter = (series[seriesKey] as int?) ?? 0;
    counter++;
    
    // Update series
    series[seriesKey] = counter;
    meta['series'] = series;
    await _db.writeMap('meta', meta);
    
    // Format: PREFIX-yyyyMMdd-###
    final number = '$prefix-$today-${counter.toString().padLeft(3, '0')}';
    
    print('[NumberSeriesService] Generated $number');
    return number;
  }

  /// Reset all series (for testing)
  Future<void> resetAll() async {
    final meta = await _db.readMap('meta');
    meta['series'] = <String, dynamic>{};
    await _db.writeMap('meta', meta);
  }
}
