import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/business_chat_repository.dart';
import '../../infra/datasources/business_chat_api.dart';

final businessChatRepositoryProvider =
    Provider<BusinessChatRepository>((ref) {
  return BusinessChatApi();
});

class BusinessChatState {
  final List<BusinessChatMessage> messages;
  final bool isLoading;
  final String? error;

  const BusinessChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  BusinessChatState copyWith({
    List<BusinessChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return BusinessChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BusinessChatNotifier extends StateNotifier<BusinessChatState> {
  final BusinessChatRepository _repository;
  final String businessId;

  BusinessChatNotifier(this._repository, this.businessId)
      : super(const BusinessChatState());

  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final messages = await _repository.getBusinessChatMessages(businessId);
      state = state.copyWith(
        messages: messages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final businessChatStateProvider = StateNotifierProvider.family<
    BusinessChatNotifier, BusinessChatState, String>((ref, businessId) {
  final notifier = BusinessChatNotifier(
    ref.watch(businessChatRepositoryProvider),
    businessId,
  );
  // Cargar mensajes solo si el businessId no está vacío
  if (businessId.isNotEmpty) {
    notifier.loadMessages();
  }
  return notifier;
});
