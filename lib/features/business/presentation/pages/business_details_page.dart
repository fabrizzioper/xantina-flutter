import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_members_page.dart';
import 'business_members_page.dart';
import '../../../chat/presentation/pages/business_chat_page.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';
import '../../domain/entities/business.dart';
import '../../domain/repositories/business_repository.dart';
import '../../infra/datasources/business_api.dart';

// Provider para obtener un negocio específico por ID
final businessByIdProvider = FutureProvider.family<Business?, String>((ref, businessId) async {
  try {
    final repository = BusinessApi();
    return await repository.getBusinessById(businessId);
  } catch (e) {
    return null;
  }
});

class BusinessDetailsPage extends ConsumerWidget {
  final String businessId;
  final String businessName;

  const BusinessDetailsPage({
    super.key,
    required this.businessId,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.authResponse?.user;
    final businessAsync = ref.watch(businessByIdProvider(businessId));
    
    return businessAsync.when(
      data: (business) {
        // Verificar si el usuario es dueño del negocio
        final isBusinessOwner = currentUser != null && 
            business != null && 
            business.userId == currentUser.id;
        
        return _buildScaffold(context, isBusinessOwner);
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF5F1E8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A2C1A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            businessName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4A2C1A),
          ),
        ),
      ),
      error: (_, __) => _buildScaffold(context, false),
    );
  }

  Widget _buildScaffold(BuildContext context, bool isBusinessOwner) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          businessName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const SizedBox(height: 24),
          // Solo mostrar "Agregar miembros" si el usuario es el dueño del negocio
          if (isBusinessOwner) ...[
            _OptionCard(
              icon: Icons.person_add,
              title: 'Agregar miembros',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(
                      businessId: businessId,
                      businessName: businessName,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          _OptionCard(
            icon: Icons.people,
            title: 'Ver miembros',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BusinessMembersPage(
                    businessId: businessId,
                    businessName: businessName,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _OptionCard(
            icon: Icons.chat,
            title: 'Chat',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BusinessChatPage(
                    businessId: businessId,
                    businessName: businessName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4A2C1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5F),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF5A5A5A),
            ),
          ],
        ),
      ),
    );
  }
}
