import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_getx_architecture/app/core/services/number_series_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_getx_architecture/app/core/services/json_db_service.dart';

class MockJsonDbService extends Mock implements JsonDbService {}

void main() {
  late NumberSeriesService numberSeriesService;
  late MockJsonDbService mockDb;

  setUp(() {
    mockDb = MockJsonDbService();
    Get.put<JsonDbService>(mockDb);
    numberSeriesService = NumberSeriesService();
  });

  tearDown(() {
    Get.reset();
  });

  group('NumberSeriesService', () {
    test('generates first invoice number correctly', () async {
      final today = DateFormat('yyyyMMdd').format(DateTime.now());
      
      // Mock empty series
      when(() => mockDb.readMap('meta')).thenAnswer(
        (_) async => {'series': <String, dynamic>{}},
      );
      when(() => mockDb.writeMap('meta', any())).thenAnswer((_) async {});

      final invoiceNo = await numberSeriesService.next('invoice');

      expect(invoiceNo, 'INV-$today-001');
      verify(() => mockDb.readMap('meta')).called(1);
      verify(() => mockDb.writeMap('meta', any())).called(1);
    });

    test('generates sequential invoice numbers', () async {
      final today = DateFormat('yyyyMMdd').format(DateTime.now());
      final seriesKey = 'invoice_$today';
      
      // Mock with existing series
      when(() => mockDb.readMap('meta')).thenAnswer(
        (_) async => {
          'series': {seriesKey: 5}
        },
      );
      when(() => mockDb.writeMap('meta', any())).thenAnswer((_) async {});

      final invoiceNo = await numberSeriesService.next('invoice');

      expect(invoiceNo, 'INV-$today-006');
    });

    test('supports custom prefix', () async {
      final today = DateFormat('yyyyMMdd').format(DateTime.now());
      
      when(() => mockDb.readMap('meta')).thenAnswer(
        (_) async => {'series': <String, dynamic>{}},
      );
      when(() => mockDb.writeMap('meta', any())).thenAnswer((_) async {});

      final purchaseNo = await numberSeriesService.next('purchase', prefix: 'PUR');

      expect(purchaseNo, 'PUR-$today-001');
    });

    test('pads numbers correctly', () async {
      final today = DateFormat('yyyyMMdd').format(DateTime.now());
      final seriesKey = 'invoice_$today';
      
      when(() => mockDb.readMap('meta')).thenAnswer(
        (_) async => {
          'series': {seriesKey: 99}
        },
      );
      when(() => mockDb.writeMap('meta', any())).thenAnswer((_) async {});

      final invoiceNo = await numberSeriesService.next('invoice');

      expect(invoiceNo, 'INV-$today-100');
    });

    test('resets series correctly', () async {
      when(() => mockDb.readMap('meta')).thenAnswer(
        (_) async => {
          'series': {'invoice_20251107': 10, 'purchase_20251107': 5}
        },
      );
      when(() => mockDb.writeMap('meta', any())).thenAnswer((_) async {});

      await numberSeriesService.resetAll();

      verify(() => mockDb.writeMap('meta', {'series': <String, dynamic>{}}))
          .called(1);
    });
  });
}
