import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/mock_coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/home/presentation/pages/home_page.dart';
import 'package:pulse_coaching_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import '../../helpers/test_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureTestDependencies(
      const AppConfig(
        flavor: AppFlavor.dev,
        appName: 'Pulse Dev',
        backend: BackendType.mock,
      ),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('home page shows coaching library and dev cards', (tester) async {
    tester.view.physicalSize = const Size(400, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final viewModel = HomeViewModel(MockCoachingVideoRepository());
    await viewModel.load();
    expect(viewModel.continueVideos, isNotEmpty);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pulse'), findsOneWidget);
    expect(find.text('Coaching library'), findsOneWidget);
    expect(find.text('CONTINUE'), findsOneWidget);
    expect(find.text('Morning Mobility Reset'), findsOneWidget);
    expect(find.text('Counter (BLoC)'), findsOneWidget);
    expect(find.text('Flavor: dev'), findsOneWidget);
  });
}
