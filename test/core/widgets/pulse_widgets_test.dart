import 'package:pulse_coaching_app/core/widgets/pulse_feature_card.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_logo.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_primary_button.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_section_header.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_text_field.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PulseLogo uses localized app title by default', (tester) async {
    await _pump(tester, const PulseLogo());

    expect(find.text('Pulse'), findsOneWidget);
  });

  testWidgets('PulsePrimaryButton supports loading and disabled states', (
    tester,
  ) async {
    var taps = 0;

    await _pump(
      tester,
      PulsePrimaryButton(
        label: 'Continue',
        isLoading: true,
        onPressed: () => taps++,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(PulsePrimaryButton));
    expect(taps, 0);
  });

  testWidgets('PulseTextField renders helper error text', (tester) async {
    await _pump(
      tester,
      const PulseTextField(
        label: 'Email',
        hintText: 'you@example.com',
        errorText: 'Email is required',
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('PulseFeatureCard handles taps', (tester) async {
    var tapped = false;

    await _pump(
      tester,
      PulseFeatureCard(
        title: 'Coaching library',
        subtitle: 'Browse sessions',
        icon: Icons.play_circle_outline,
        badge: '4 sessions',
        onTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byType(PulseFeatureCard));

    expect(tapped, isTrue);
    expect(find.text('4 sessions'), findsOneWidget);
  });

  testWidgets('PulseSectionHeader uppercases labels', (tester) async {
    await _pump(tester, const PulseSectionHeader(label: 'Explore'));

    expect(find.text('EXPLORE'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
