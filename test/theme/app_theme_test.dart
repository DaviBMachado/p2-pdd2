import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('defines all 7 official Retro Analog hex colors', () {
      expect(AppColors.background, const Color(0xFFF4EBD8));
      expect(AppColors.surface, const Color(0xFFFFF9ED));
      expect(AppColors.secondary, const Color(0xFFE8D7B5));
      expect(AppColors.primary, const Color(0xFFD96C3B));
      expect(AppColors.accent, const Color(0xFF68734B));
      expect(AppColors.text, const Color(0xFF293B35));
      expect(AppColors.border, const Color(0xFFB8A98E));
    });
  });

  group('AppTheme.retroAnalog ColorScheme & Scaffold', () {
    test('uses Material 3, #F4EBD8 scaffold background, and 7-color ColorScheme', () {
      final theme = AppTheme.retroAnalog;
      final officialPalette = <Color>{
        Color(0xFFF4EBD8),
        Color(0xFFFFF9ED),
        Color(0xFFE8D7B5),
        Color(0xFFD96C3B),
        Color(0xFF68734B),
        Color(0xFF293B35),
        Color(0xFFB8A98E),
      };

      expect(theme.useMaterial3, isTrue);
      expect(theme.scaffoldBackgroundColor, const Color(0xFFF4EBD8));

      final scheme = theme.colorScheme;
      expect(scheme.brightness, Brightness.light);
      expect(scheme.primary, const Color(0xFFD96C3B));
      expect(scheme.onPrimary, const Color(0xFFFFF9ED));
      expect(scheme.secondary, const Color(0xFFE8D7B5));
      expect(scheme.onSecondary, const Color(0xFF293B35));
      expect(scheme.tertiary, const Color(0xFF68734B));
      expect(scheme.onTertiary, const Color(0xFFFFF9ED));
      expect(scheme.surface, const Color(0xFFFFF9ED));
      expect(scheme.onSurface, const Color(0xFF293B35));
      expect(scheme.outline, const Color(0xFFB8A98E));
      expect(scheme.surfaceContainerHighest, const Color(0xFFE8D7B5));
      expect(scheme.error, const Color(0xFFD96C3B));
      expect(scheme.onError, const Color(0xFFFFF9ED));

      for (final c in <Color>[
        scheme.primary,
        scheme.onPrimary,
        scheme.secondary,
        scheme.onSecondary,
        scheme.tertiary,
        scheme.onTertiary,
        scheme.surface,
        scheme.onSurface,
        scheme.outline,
        scheme.surfaceContainerHighest,
        scheme.error,
        scheme.onError,
      ]) {
        expect(officialPalette.contains(c), isTrue);
      }
    });
  });

  group('AppTheme.retroAnalog TextTheme', () {
    test('assigns BricolageGrotesque, DMSans, and SpaceMono with #293B35 color', () {
      final textTheme = AppTheme.retroAnalog.textTheme;
      const expectedColor = Color(0xFF293B35);

      for (final style in <TextStyle?>[
        textTheme.displayLarge,
        textTheme.displayMedium,
        textTheme.displaySmall,
        textTheme.headlineLarge,
        textTheme.headlineMedium,
        textTheme.headlineSmall,
        textTheme.titleLarge,
        textTheme.titleMedium,
        textTheme.titleSmall,
      ]) {
        expect(style?.fontFamily, 'BricolageGrotesque');
        expect(style?.color, expectedColor);
      }

      for (final style in <TextStyle?>[
        textTheme.bodyLarge,
        textTheme.bodyMedium,
        textTheme.bodySmall,
        textTheme.labelLarge,
      ]) {
        expect(style?.fontFamily, 'DMSans');
        expect(style?.color, expectedColor);
      }

      for (final style in <TextStyle?>[
        textTheme.labelMedium,
        textTheme.labelSmall,
      ]) {
        expect(style?.fontFamily, 'SpaceMono');
        expect(style?.color, expectedColor);
      }
    });
  });

  group('AppTheme Paper Card, Solid Retro Button & Tokens', () {
    test('exposes spacing/radius tokens and Paper Card styling (#FFF9ED, #B8A98E border)', () {
      expect(AppTheme.spacingSm, 8.0);
      expect(AppTheme.spacingMd, 16.0);
      expect(AppTheme.radiusMd, 10.0);
      expect(AppTheme.radiusLg, 12.0);

      final decoration = AppTheme.paperCardDecoration;
      expect(decoration.color, const Color(0xFFFFF9ED));
      expect(decoration.border, isA<Border>());
      final border = decoration.border! as Border;
      expect(border.top.color, const Color(0xFFB8A98E));
      expect(decoration.borderRadius, BorderRadius.circular(12.0));

      final cardTheme = AppTheme.retroAnalog.cardTheme;
      expect(cardTheme.color, const Color(0xFFFFF9ED));
      expect(cardTheme.surfaceTintColor, const Color(0xFFFFF9ED));
      expect(cardTheme.elevation, 0);
      expect(cardTheme.shape, isA<RoundedRectangleBorder>());
      final shape = cardTheme.shape! as RoundedRectangleBorder;
      expect(shape.side.color, const Color(0xFFB8A98E));
      expect(shape.borderRadius, BorderRadius.circular(12.0));
    });

    test('configures Solid Retro ElevatedButton (#D96C3B, #FFF9ED, >=48dp, DMSans bold)', () {
      final style = AppTheme.solidRetroButtonStyle;
      expect(style.backgroundColor?.resolve(<WidgetState>{}), const Color(0xFFD96C3B));
      expect(style.foregroundColor?.resolve(<WidgetState>{}), const Color(0xFFFFF9ED));
      expect(style.elevation?.resolve(<WidgetState>{}), 0);
      final minSize = style.minimumSize?.resolve(<WidgetState>{});
      expect(minSize, isNotNull);
      expect(minSize!.width, greaterThanOrEqualTo(48.0));
      expect(minSize.height, greaterThanOrEqualTo(48.0));
      final textStyle = style.textStyle?.resolve(<WidgetState>{});
      expect(textStyle?.fontFamily, 'DMSans');
      expect(textStyle?.fontWeight, FontWeight.w700);
      expect(
        AppTheme.retroAnalog.elevatedButtonTheme.style,
        AppTheme.solidRetroButtonStyle,
      );
    });
  });

  group('AppTheme InputDecoration, AppBar, SnackBar & MaterialApp smoke test', () {
    test('configures InputDecorationThemeData (#FFF9ED fill, #B8A98E border, #D96C3B focus)', () {
      final inputTheme = AppTheme.retroAnalog.inputDecorationTheme;
      expect(inputTheme.filled, isTrue);
      expect(inputTheme.fillColor, const Color(0xFFFFF9ED));

      expect(inputTheme.border, isA<OutlineInputBorder>());
      expect((inputTheme.border! as OutlineInputBorder).borderSide.color, const Color(0xFFB8A98E));

      expect(inputTheme.enabledBorder, isA<OutlineInputBorder>());
      expect((inputTheme.enabledBorder! as OutlineInputBorder).borderSide.color, const Color(0xFFB8A98E));

      expect(inputTheme.focusedBorder, isA<OutlineInputBorder>());
      expect((inputTheme.focusedBorder! as OutlineInputBorder).borderSide.color, const Color(0xFFD96C3B));

      expect(inputTheme.errorBorder, isA<OutlineInputBorder>());
      expect((inputTheme.errorBorder! as OutlineInputBorder).borderSide.color, const Color(0xFFD96C3B));
    });

    test('configures AppBarThemeData (#F4EBD8 bg, #293B35 fg, BricolageGrotesque title)', () {
      final appBarTheme = AppTheme.retroAnalog.appBarTheme;
      expect(appBarTheme.backgroundColor, const Color(0xFFF4EBD8));
      expect(appBarTheme.foregroundColor, const Color(0xFF293B35));
      expect(appBarTheme.elevation, 0);
      expect(appBarTheme.scrolledUnderElevation, 0);
      expect(appBarTheme.titleTextStyle?.fontFamily, 'BricolageGrotesque');
      expect(appBarTheme.titleTextStyle?.color, const Color(0xFF293B35));
    });

    test('configures SnackBarThemeData (#293B35 bg, DMSans #FFF9ED text, floating)', () {
      final snackBarTheme = AppTheme.retroAnalog.snackBarTheme;
      expect(snackBarTheme.backgroundColor, const Color(0xFF293B35));
      expect(snackBarTheme.contentTextStyle?.fontFamily, 'DMSans');
      expect(snackBarTheme.contentTextStyle?.color, const Color(0xFFFFF9ED));
      expect(snackBarTheme.behavior, SnackBarBehavior.floating);
    });

    testWidgets('MaterialApp applies AppTheme.retroAnalog to rendered widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.retroAnalog,
          home: Scaffold(
            appBar: AppBar(title: const Text('TaskFlow')),
            body: Column(
              children: [
                const Card(child: Text('Retro Card')),
                const TextField(),
                ElevatedButton(onPressed: () {}, child: const Text('Salvar')),
              ],
            ),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(Scaffold));
      final appliedTheme = Theme.of(context);
      expect(appliedTheme.scaffoldBackgroundColor, const Color(0xFFF4EBD8));
      expect(appliedTheme.appBarTheme.backgroundColor, const Color(0xFFF4EBD8));
      expect(appliedTheme.cardTheme.color, const Color(0xFFFFF9ED));
      expect(appliedTheme.inputDecorationTheme.fillColor, const Color(0xFFFFF9ED));
      expect(find.text('TaskFlow'), findsOneWidget);
      expect(find.text('Retro Card'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
    });
  });
}
