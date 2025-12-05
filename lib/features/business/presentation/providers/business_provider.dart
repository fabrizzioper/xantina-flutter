import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/business.dart';
import '../../infra/datasources/business_api.dart';
import '../../domain/repositories/business_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessApi();
});

class BusinessState {
  final List<Business> businesses;
  final bool isLoading;
  final String? error;

  const BusinessState({
    this.businesses = const [],
    this.isLoading = false,
    this.error,
  });

  BusinessState copyWith({
    List<Business>? businesses,
    bool? isLoading,
    String? error,
  }) {
    return BusinessState(
      businesses: businesses ?? this.businesses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BusinessNotifier extends StateNotifier<BusinessState> {
  final BusinessRepository _businessRepository;

  BusinessNotifier(this._businessRepository)
      : super(const BusinessState());

  Future<void> loadBusinesses() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final businesses = await _businessRepository.getBusinesses();
      state = state.copyWith(
        businesses: businesses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createBusiness({
    required String name,
    required String type,
    required String phone,
    required String address,
    String? description,
    String? logo,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final newBusiness = await _businessRepository.createBusiness(
        name: name,
        type: type,
        phone: phone,
        address: address,
        description: description,
        logo: logo,
      );
      
      state = state.copyWith(
        businesses: [...state.businesses, newBusiness],
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

final businessStateProvider =
    StateNotifierProvider<BusinessNotifier, BusinessState>((ref) {
  return BusinessNotifier(ref.watch(businessRepositoryProvider));
});
