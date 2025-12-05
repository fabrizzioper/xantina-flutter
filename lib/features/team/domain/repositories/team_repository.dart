import 'package:xantina/features/user-auth/domain/entities/app_user.dart';

abstract class TeamRepository {
  Future<List<AppUser>> getTeamUsers();
  Future<AppUser> createTeamUser({
    required String name,
    required String email,
    required String password,
    required String image,
  });
}
