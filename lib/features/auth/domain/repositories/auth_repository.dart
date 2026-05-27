import 'package:pulse_coaching_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchUser();

  Future<AppUser> signIn({required String email, required String password});

  Future<void> signOut();
}
