import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';
import '../../infra/datasources/business_member_api.dart';
import '../../domain/repositories/business_member_repository.dart';

final businessMemberRepositoryProvider =
    Provider<BusinessMemberRepository>((ref) {
  return BusinessMemberApi();
});

class BusinessMemberState {
  final List<AppUser> members;
  final bool isLoading;
  final String? error;

  const BusinessMemberState({
    this.members = const [],
    this.isLoading = false,
    this.error,
  });

  BusinessMemberState copyWith({
    List<AppUser>? members,
    bool? isLoading,
    String? error,
  }) {
    return BusinessMemberState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BusinessMemberNotifier
    extends StateNotifier<BusinessMemberState> {
  final BusinessMemberRepository _repository;

  BusinessMemberNotifier(this._repository) : super(const BusinessMemberState());

  Future<void> loadMembers(String businessId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final members = await _repository.getBusinessMembers(businessId);
      state = state.copyWith(
        members: members,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addMembers({
    required String businessId,
    required List<String> userIds,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedMembers = await _repository.addMembers(
        businessId: businessId,
        userIds: userIds,
      );
      state = state.copyWith(
        members: updatedMembers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

final businessMemberStateProvider = StateNotifierProvider.family<
    BusinessMemberNotifier, BusinessMemberState, String>((ref, businessId) {
  return BusinessMemberNotifier(ref.watch(businessMemberRepositoryProvider));
});
