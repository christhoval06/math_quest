import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Nunito weights are bundled and load without a font download', (
    tester,
  ) async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    final families = manifest
        .where((family) => family['family'] == 'Nunito')
        .toList();
    expect(
      families,
      hasLength(1),
      reason: 'Nunito must be included in the application asset bundle.',
    );
    final fonts = families.single['fonts'] as List;
    expect(fonts.map((font) => font['weight']).toList()..sort(), [
      400,
      500,
      600,
      700,
      800,
      900,
    ]);
    final fontData = <ByteData>[];
    for (final font in fonts) {
      final data = await rootBundle.load(font['asset'] as String);
      expect(data.lengthInBytes, greaterThan(1000));
      expect(
        data.getUint32(0),
        0x00010000,
        reason: 'The bundled resource must be a TrueType font.',
      );
      fontData.add(data);
    }
    await tester.runAsync(() async {
      final loader = FontLoader('Nunito');
      for (final data in fontData) {
        loader.addFont(Future.value(data));
      }
      await loader.load();
    });
  });
}
