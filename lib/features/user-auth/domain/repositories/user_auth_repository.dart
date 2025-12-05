import '../entities/app_user.dart';

abstract class UserAuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String? image,
  });
  Future<AppUser> updateProfile({
    String? name,
    String? email,
    String? image,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class AuthResponse {
  final String accessToken;
  final AppUser user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });
}
