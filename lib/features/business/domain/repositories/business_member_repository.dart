import 'package:xantina/features/user-auth/domain/entities/app_user.dart';

abstract class BusinessMemberRepository {
  Future<List<AppUser>> getBusinessMembers(String businessId);
  Future<List<AppUser>> addMembers({
    required String businessId,
    required List<String> userIds,
  });
}
