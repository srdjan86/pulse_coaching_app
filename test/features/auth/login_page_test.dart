import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/presentation/pages/login_page.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import '../../helpers/test_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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

  tearDown(() => getIt.reset());

  AuthViewModel makeViewModel() => AuthViewModel(MockAuthRepository());

  Future<void> pumpLogin(
    WidgetTester tester, {
    AuthViewModel? viewModel,
    bool withRouter = false,
  }) async {
    final page = LoginPage(viewModel: viewModel ?? makeViewModel());

    if (withRouter) {
      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(path: '/login', builder: (ctx, st) => page),
          GoRoute(
            path: '/',
            builder: (ctx, st) => const Scaffold(body: Text('home')),
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
    } else {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: page,
        ),
      );
    }
    await tester.pumpAndSettle();
  }

  testWidgets('shows title, email field, password field, and sign-in button', (
    tester,
  ) async {
    await pumpLogin(tester);

    expect(find.text('Sign in to Pulse'), findsOneWidget);
    expect(find.byKey(const Key('login_email')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
    expect(find.byKey(const Key('login_submit')), findsOneWidget);
  });

  testWidgets('shows error when submitting with empty fields', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows error when only email is empty', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(_fieldByKey('login_password'), 'password');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsNothing);
  });

  testWidgets('valid credentials show loading then navigate to home', (
    tester,
  ) async {
    await pumpLogin(tester, withRouter: true);

    await tester.enterText(_fieldByKey('login_email'), 'demo@example.com');
    await tester.enterText(_fieldByKey('login_password'), 'password');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.byKey(const Key('login_submit')), findsNothing);
  });

  testWidgets('shows mock credentials hint on mock backend', (tester) async {
    await pumpLogin(tester);

    expect(
      find.text('Mock backend demo: demo@example.com / password'),
      findsOneWidget,
    );
  });

  testWidgets('shows error for invalid email format', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(_fieldByKey('login_email'), 'not-an-email');
    await tester.enterText(_fieldByKey('login_password'), 'password');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('home'), findsNothing);
  });

  testWidgets('shows error and stays on login for wrong password', (
    tester,
  ) async {
    await pumpLogin(tester, withRouter: true);

    await tester.enterText(_fieldByKey('login_email'), 'demo@example.com');
    await tester.enterText(_fieldByKey('login_password'), 'wrong-password');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(
      find.text('Email or password is incorrect. Please try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('login_submit')), findsOneWidget);
    expect(find.text('home'), findsNothing);
  });

  testWidgets('mock backend hides sign-up toggle', (tester) async {
    await pumpLogin(tester);

    expect(find.byKey(const Key('auth_mode_toggle')), findsNothing);
    expect(find.text('New to Pulse?'), findsNothing);
  });

  testWidgets('supabase backend toggles between sign in and sign up', (
    tester,
  ) async {
    await getIt.reset();
    await configureTestDependencies(
      const AppConfig(
        flavor: AppFlavor.staging,
        appName: 'Pulse Staging',
        backend: BackendType.supabase,
        supabaseUrl: 'https://example.supabase.co',
        supabaseAnonKey: 'test-key',
      ),
    );

    await pumpLogin(tester);

    expect(find.text('Sign in to Pulse'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);

    await tester.tap(find.byKey(const Key('auth_mode_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Sign in to Pulse'), findsNothing);

    await tester.tap(find.byKey(const Key('auth_mode_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to Pulse'), findsOneWidget);
  });
}

Finder _fieldByKey(String key) {
  return find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(TextField),
  );
}
