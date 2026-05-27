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
  });
}
