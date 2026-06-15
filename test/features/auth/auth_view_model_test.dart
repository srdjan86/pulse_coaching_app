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
  });
}
