import 'package:pulse_coaching_app/core/errors/auth_failure.dart';
import 'package:pulse_coaching_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:pulse_coaching_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthViewModel', () {
    late MockAuthRepository repository;
    late AuthViewModel viewModel;

    setUp(() {
      repository = MockAuthRepository();
      viewModel = AuthViewModel(repository);
    });

    AuthViewModel viewModelWith(MockAuthRepository repo) => AuthViewModel(repo);

    tearDown(() {
      viewModel.dispose();
    });

    test('starts signed out', () {
      expect(viewModel.isSignedIn, isFalse);
      expect(viewModel.user, isNull);
    });

    test('signs in and out with mock backend', () async {
      await viewModel.signIn(email: 'demo@example.com', password: 'password');

      expect(viewModel.isSignedIn, isTrue);
      expect(viewModel.user?.email, 'demo@example.com');

      await viewModel.signOut();

      expect(viewModel.isSignedIn, isFalse);
    });

    test('validates empty login fields before sign in', () async {
      final didSignIn = await viewModel.submitSignIn();

      expect(didSignIn, isFalse);
      expect(viewModel.isSignedIn, isFalse);
      expect(
        viewModel.emailValidationError,
        LoginFieldValidationError.required,
      );
      expect(
        viewModel.passwordValidationError,
        LoginFieldValidationError.required,
      );
    });

    test('clears login validation errors as fields are updated', () async {
      await viewModel.submitSignIn();

      viewModel.updateEmail('demo@example.com');
      viewModel.updatePassword('password');

      expect(viewModel.emailValidationError, isNull);
      expect(viewModel.passwordValidationError, isNull);
    });

    test('submits sign in with valid login fields', () async {
      viewModel.updateEmail('demo@example.com');
      viewModel.updatePassword('password');

      final didSignIn = await viewModel.submitSignIn();

      expect(didSignIn, isTrue);
      expect(viewModel.isSignedIn, isTrue);
      expect(viewModel.user?.email, 'demo@example.com');
    });

    test('rejects invalid credentials on mock backend', () async {
      viewModel.updateEmail('demo@example.com');
      viewModel.updatePassword('wrong-password');

      final didSignIn = await viewModel.submitSignIn();

      expect(didSignIn, isFalse);
      expect(viewModel.isSignedIn, isFalse);
      expect(viewModel.errorMessage, 'invalid_login_credentials');
    });

    test('rejects invalid email format before sign in', () async {
      viewModel.updateEmail('not-an-email');
      viewModel.updatePassword('password');

      final didSignIn = await viewModel.submitSignIn();

      expect(didSignIn, isFalse);
      expect(viewModel.isSignedIn, isFalse);
      expect(
        viewModel.emailValidationError,
        LoginFieldValidationError.invalidEmail,
      );
    });

    test('rejects short password on sign up', () async {
      viewModel.updateEmail('new@example.com');
      viewModel.updatePassword('123');

      final didSignUp = await viewModel.submitSignUp();

      expect(didSignUp, isFalse);
      expect(viewModel.isSignedIn, isFalse);
      expect(
        viewModel.passwordValidationError,
        LoginFieldValidationError.passwordTooShort,
      );
    });

    test('email confirmation does not count as signed in', () async {
      final confirmationViewModel = viewModelWith(
        MockAuthRepository(signUpRequiresEmailConfirmation: true),
      );
      addTearDown(confirmationViewModel.dispose);

      confirmationViewModel.updateEmail('new@example.com');
      confirmationViewModel.updatePassword('password123');

      final didSignUp = await confirmationViewModel.submitSignUp();

      expect(didSignUp, isFalse);
      expect(confirmationViewModel.isSignedIn, isFalse);
      expect(confirmationViewModel.needsEmailConfirmation, isTrue);
      expect(
        confirmationViewModel.infoMessage,
        'sign_up_confirmation_required',
      );
    });

    test('handleEmailConfirmationDeepLink shows expired link error', () async {
      final pending = viewModel.handleEmailConfirmationDeepLink();

      expect(viewModel.isVerifyingEmailConfirmation, isTrue);

      await pending;

      expect(viewModel.errorMessage, 'email_link_expired');
      expect(viewModel.infoMessage, isNull);
      expect(viewModel.isVerifyingEmailConfirmation, isFalse);
    });

    test(
      'handleEmailConfirmationDeepLink uses buffered auth failure',
      () async {
        final repo = MockAuthRepository()
          ..pendingAuthFailure = const AuthFailure('email_link_expired');
        final deepLinkViewModel = AuthViewModel(repo);
        addTearDown(deepLinkViewModel.dispose);

        await deepLinkViewModel.handleEmailConfirmationDeepLink();

        expect(deepLinkViewModel.errorMessage, 'email_link_expired');
        expect(deepLinkViewModel.infoMessage, isNull);
      },
    );

    test('handleEmailConfirmationDeepLink shows signed in success', () async {
      await viewModel.signIn(email: 'demo@example.com', password: 'password');

      await viewModel.handleEmailConfirmationDeepLink();

      expect(viewModel.infoMessage, 'email_confirmed_signed_in');
      expect(viewModel.isSignedIn, isTrue);
    });

    test('resetAuthFormFeedback clears validation and messages', () async {
      await viewModel.submitSignIn();

      viewModel.resetAuthFormFeedback();

      expect(viewModel.emailValidationError, isNull);
      expect(viewModel.passwordValidationError, isNull);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.infoMessage, isNull);
      expect(viewModel.needsEmailConfirmation, isFalse);
    });
  });
}
