import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/presentation/providers/business_provider.dart';
import '../../../business/presentation/providers/business_member_provider.dart';
import '../../../team/presentation/providers/team_provider.dart';
import 'business_chat_page.dart';
import 'private_chat_page.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';
import '../../../../core/utils/image_helpers.dart';

class UserChatPage extends ConsumerStatefulWidget {
  const UserChatPage({super.key});

  @override
  ConsumerState<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends ConsumerState<UserChatPage> {
  @override
  void initState() {
    super.initState();
    // Cargar negocios y usuarios del equipo al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessStateProvider.notifier).loadBusinesses();
      final authState = ref.read(authStateProvider);
      if (authState.authResponse?.user.role == 'admin') {
        ref.read(teamStateProvider.notifier).loadTeamUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessStateProvider);
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.authResponse?.user;
    final isAdmin = currentUser?.role == 'admin';
    final isLoading = businessState.isLoading;
    
    // Obtener usuarios del equipo si es admin
    final teamState = isAdmin ? ref.watch(teamStateProvider) : null;
    final teamUsers = teamState?.users ?? [];

    // Filtrar negocios donde el usuario es miembro
    final userBusinesses = businessState.businesses;
    
    // Para admin: contar negocios + usuarios del equipo
    // Para usuarios: solo contar negocios
    final totalItems = isAdmin 
        ? userBusinesses.length + teamUsers.length
        : userBusinesses.length;
    
    final isLoadingTeam = isAdmin && (teamState?.isLoading ?? false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: (isLoading || isLoadingTeam)
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A2C1A),
              ),
            )
          : totalItems == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isAdmin ? 'No tienes negocios ni miembros del equipo' : 'No tienes negocios',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isAdmin 
                            ? 'Crea un negocio o agrega miembros a tu equipo'
                            : 'Únete a un negocio para comenzar a chatear',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(businessStateProvider.notifier).loadBusinesses();
                    if (isAdmin) {
                      await ref.read(teamStateProvider.notifier).loadTeamUsers();
                    }
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: totalItems,
                    itemBuilder: (context, index) {
                      // Si es admin, primero mostrar negocios, luego miembros del equipo
                      if (isAdmin) {
                        if (index < userBusinesses.length) {
                          // Mostrar negocios
                          final business = userBusinesses[index];
                          final isCurrentUserAdmin = currentUser?.id == business.userId;
                          
                          if (isCurrentUserAdmin) {
                            return _BusinessChatCard(
                              business: business,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BusinessChatPage(
                                      businessId: business.id,
                                      businessName: business.name,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          
                          return _BusinessChatOptionsCard(
                            business: business,
                            currentUserId: currentUser?.id ?? '',
                            onBusinessChatTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BusinessChatPage(
                                    businessId: business.id,
                                    businessName: business.name,
                                  ),
                                ),
                              );
                            },
                            onAdminChatTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PrivateChatPage(
                                    otherUserId: business.userId,
                                    otherUserName: 'Administrador',
                                    otherUserImage: null,
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          // Mostrar miembros del equipo
                          final teamUserIndex = index - userBusinesses.length;
                          if (teamUserIndex < teamUsers.length) {
                            final teamUser = teamUsers[teamUserIndex];
                            return _TeamMemberChatCard(
                              user: teamUser,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PrivateChatPage(
                                      otherUserId: teamUser.id,
                                      otherUserName: teamUser.name,
                                      otherUserImage: teamUser.image,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      } else {
                        // Para usuarios normales, solo mostrar negocios
                        if (index < userBusinesses.length) {
                          final business = userBusinesses[index];
                          return _BusinessChatOptionsCard(
                            business: business,
                            currentUserId: currentUser?.id ?? '',
                            onBusinessChatTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BusinessChatPage(
                                    businessId: business.id,
                                    businessName: business.name,
                                  ),
                                ),
                              );
                            },
                            onAdminChatTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PrivateChatPage(
                                    otherUserId: business.userId,
                                    otherUserName: 'Administrador',
                                    otherUserImage: null,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                      
                      return const SizedBox.shrink();
                    },
                  ),
                ),
    );
  }
}

class _BusinessChatCard extends StatelessWidget {
  final dynamic business;
  final VoidCallback onTap;

  const _BusinessChatCard({
    required this.business,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Logo del negocio
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageHelpers.buildBusinessLogo(
                  business.logo,
                  size: 60,
                ),
              ),
              const SizedBox(width: 16),
              // Información del negocio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A3A5F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business.address ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Icono de chat
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF4A2C1A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessChatOptionsCard extends StatelessWidget {
  final dynamic business;
  final String currentUserId;
  final VoidCallback onBusinessChatTap;
  final VoidCallback onAdminChatTap;

  const _BusinessChatOptionsCard({
    required this.business,
    required this.currentUserId,
    required this.onBusinessChatTap,
    required this.onAdminChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información del negocio
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageHelpers.buildBusinessLogo(
                    business.logo,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A3A5F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        business.address ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Opción 1: Chat del negocio (grupal)
            InkWell(
              onTap: onBusinessChatTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A2C1A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.group,
                        color: Color(0xFF4A2C1A),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Chat del negocio',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A3A5F),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF4A2C1A),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Opción 2: Chat con administrador (privado)
            InkWell(
              onTap: onAdminChatTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A2C1A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF4A2C1A),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Chat con administrador',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A3A5F),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF4A2C1A),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberChatCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;

  const _TeamMemberChatCard({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Foto de perfil del usuario
              ClipOval(
                child: ImageHelpers.buildBase64Image(
                  user.image,
                  size: 50,
                ),
              ),
              const SizedBox(width: 16),
              // Información del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A3A5F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Icono de chat
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF4A2C1A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
