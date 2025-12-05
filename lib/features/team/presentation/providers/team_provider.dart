import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';
import '../../infra/datasources/team_api.dart';
import '../../domain/repositories/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamApi();
});

class TeamState {
  final List<AppUser> users;
  final bool isLoading;
  final String? error;

  const TeamState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  TeamState copyWith({
    List<AppUser>? users,
    bool? isLoading,
    String? error,
  }) {
    return TeamState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TeamNotifier extends StateNotifier<TeamState> {
  final TeamRepository _teamRepository;

  TeamNotifier(this._teamRepository) : super(const TeamState());

  Future<void> loadTeamUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final users = await _teamRepository.getTeamUsers();
      state = state.copyWith(
        users: users,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createTeamUser({
    required String name,
    required String email,
    required String password,
    required String image,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final newUser = await _teamRepository.createTeamUser(
        name: name,
        email: email,
        password: password,
        image: image,
      );
      
      state = state.copyWith(
        users: [...state.users, newUser],
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

final teamStateProvider =
    StateNotifierProvider<TeamNotifier, TeamState>((ref) {
  return TeamNotifier(ref.watch(teamRepositoryProvider));
});
