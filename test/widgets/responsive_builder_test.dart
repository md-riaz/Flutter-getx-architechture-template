import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/widgets/responsive_builder.dart';

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('detects mobile device type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final deviceType = ResponsiveBuilder.getDeviceType(context);
                return Text('Device: ${deviceType.name}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Device: mobile'), findsOneWidget);
    });

    testWidgets('detects tablet device type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(700, 1024)),
            child: Builder(
              builder: (context) {
                final deviceType = ResponsiveBuilder.getDeviceType(context);
                return Text('Device: ${deviceType.name}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Device: tablet'), findsOneWidget);
    });

    testWidgets('detects desktop device type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: Builder(
              builder: (context) {
                final deviceType = ResponsiveBuilder.getDeviceType(context);
                return Text('Device: ${deviceType.name}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Device: desktop'), findsOneWidget);
    });

    testWidgets('responsive extension returns correct values',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (context) {
                final padding = context.responsive(
                  mobile: 16.0,
                  tablet: 24.0,
                  desktop: 32.0,
                );
                return Text('Padding: $padding');
              },
            ),
          ),
        ),
      );

      expect(find.text('Padding: 16.0'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder.custom renders mobile layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveBuilder.custom(
              mobile: (context) => const Text('Mobile Layout'),
              tablet: (context) => const Text('Tablet Layout'),
              desktop: (context) => const Text('Desktop Layout'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile Layout'), findsOneWidget);
    });

    testWidgets('ResponsiveBuilder builder pattern works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ResponsiveBuilder(
              builder: (context, deviceType) {
                return Text('Type: ${deviceType.name}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Type: desktop'), findsOneWidget);
    });
  });

  group('Breakpoints', () {
    test('has correct values', () {
      expect(Breakpoints.mobile, 600);
      expect(Breakpoints.tablet, 900);
      expect(Breakpoints.desktop, 1200);
    });
  });
}
