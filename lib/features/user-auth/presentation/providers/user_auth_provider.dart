import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_storage.dart';
import '../../infra/datasources/user_auth_api.dart';
import '../../domain/repositories/user_auth_repository.dart';

final userAuthApiProvider = Provider<UserAuthRepository>((ref) {
  return UserAuthApi();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(userAuthApiProvider))..loadUser();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final UserAuthRepository _userAuthRepository;

  AuthNotifier(this._userAuthRepository) : super(const AuthState.initial());

  Future<void> loadUser() async {
    final user = await LocalStorage.getUser();
    final token = await LocalStorage.getAccessToken();
    if (user != null && token != null) {
      state = AuthState.authenticated(
        AuthResponse(accessToken: token, user: user),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final response = await _userAuthRepository.login(email, password);
      
      // Guardar token y usuario
      await LocalStorage.saveAccessToken(response.accessToken);
      await LocalStorage.saveUser(response.user);
      
      state = AuthState.authenticated(response);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? image,
  }) async {
    state = const AuthState.loading();
    
    try {
      final response = await _userAuthRepository.register(
        name: name,
        email: email,
        password: password,
        image: image,
      );
      state = AuthState.authenticated(response);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await LocalStorage.clear();
    state = const AuthState.initial();
  }
}

class AuthState {
  final bool isLoading;
  final AuthResponse? authResponse;
  final String? error;

  const AuthState({
    required this.isLoading,
    this.authResponse,
    this.error,
  });

  const AuthState.initial()
      : isLoading = false,
        authResponse = null,
        error = null;

  const AuthState.loading()
      : isLoading = true,
        authResponse = null,
        error = null;

  const AuthState.authenticated(this.authResponse)
      : isLoading = false,
        error = null;

  const AuthState.error(this.error)
      : isLoading = false,
        authResponse = null;

  bool get isAuthenticated => authResponse != null;
}
