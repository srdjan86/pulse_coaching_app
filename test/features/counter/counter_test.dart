import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:pulse_coaching_app/features/counter/presentation/bloc/counter_state.dart';
import 'package:pulse_coaching_app/features/counter/presentation/pages/counter_page.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterBloc', () {
    late CounterRepositoryImpl repository;

    setUp(() {
      repository = CounterRepositoryImpl();
    });

    blocTest<CounterBloc, CounterState>(
      'loads initial value on start',
      build: () => CounterBloc(repository),
      act: (bloc) => bloc.add(const CounterStarted()),
      expect: () => [const CounterState(value: 0)],
    );

    blocTest<CounterBloc, CounterState>(
      'increments value',
      build: () => CounterBloc(repository),
      act: (bloc) => bloc.add(const CounterIncrementPressed()),
      expect: () => [const CounterState(value: 1)],
    );
  });

  group('CounterPage', () {
    setUp(() async {
      await getIt.reset();
      await configureDependencies(
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

    testWidgets('increments when FAB is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider(
            create: (_) => getIt<CounterBloc>()..add(const CounterStarted()),
            child: const CounterPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
