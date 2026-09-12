import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constants', () {
    test('BASE_IMAGE_URL should have correct value', () {
      expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    });

    test('Color constants should have correct values', () {
      expect(kRichBlack, const Color(0xFF000814));
      expect(kOxfordBlue, const Color(0xFF001D3D));
      expect(kPrussianBlue, const Color(0xFF003566));
      expect(kMikadoYellow, const Color(0xFFffc300));
      expect(kDavysGrey, const Color(0xFF4B5358));
      expect(kGrey, const Color(0xFF303030));
    });

    test('drawerTheme should be defined', () {
      expect(drawerTheme, isNotNull);
      expect(drawerTheme.backgroundColor, Colors.grey.shade700);
    });

    test('colorScheme should have correct colors', () {
      expect(colorScheme.primary, kMikadoYellow);
      expect(colorScheme.surface, kRichBlack);
      expect(colorScheme.secondary, kPrussianBlue);
      expect(colorScheme.onPrimary, kRichBlack);
    });
  });
}
