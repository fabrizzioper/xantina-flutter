import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/image_helpers.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';
import '../providers/team_provider.dart';
import 'add_user_page.dart';
import 'edit_member_page.dart';
import '../../../chat/presentation/pages/private_chat_page.dart';
import '../../../business/presentation/pages/my_businesses_page.dart';
import '../../../alerts/presentation/pages/alerts_page.dart';

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Cargar usuarios cuando se inicia la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamStateProvider.notifier).loadTeamUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A), // Marrรณn oscuro
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Miembros del Equipo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUserPage(),
            ),
          );
          
          if (result == true) {
            ref.read(teamStateProvider.notifier).loadTeamUsers();
          }
        },
        backgroundColor: const Color(0xFF4A2C1A), // Marrรณn oscuro
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1E8), // Beige claro
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomNavItem(
                icon: Icons.home,
                label: 'Inicio',
                isActive: _currentIndex == 0,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              _BottomNavItem(
                icon: Icons.notifications,
                label: 'Actualizaciones',
                isActive: _currentIndex == 1,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlertsPage(),
                    ),
                  );
                },
              ),
              _BottomNavItem(
                icon: Icons.business,
                label: 'Negocio',
                isActive: _currentIndex == 2,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyBusinessesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final teamState = ref.watch(teamStateProvider);
    final users = teamState.users;

    if (teamState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4A2C1A),
        ),
      );
    }

    if (teamState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${teamState.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(teamStateProvider.notifier).loadTeamUsers();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A2C1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'No tienes usuarios',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A5F),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Usa el botón + para agregar usuarios a tu equipo',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A5A5A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(teamStateProvider.notifier).loadTeamUsers();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _TeamMemberCard(
            userId: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            image: user.image,
          );
        },
      ),
    );
  }
}

class _TeamMemberCard extends ConsumerWidget {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? image;

  const _TeamMemberCard({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.image,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0), // Gris claro
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto de perfil
          ImageHelpers.buildBase64Image(image, size: 50),
          const SizedBox(height: 16),
          // Nombre - Centrado
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3A5F), // Azul oscuro
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Email - Centrado
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5A5A5A), // Gris oscuro
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: role == 'admin'
                  ? const Color(0xFF4A2C1A).withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role == 'admin' ? 'Dueño' : 'Usuario',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: role == 'admin'
                    ? const Color(0xFF4A2C1A)
                    : Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Botones de acción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón Editar
                Expanded(
                  child: _ActionButton(
                    icon: Icons.edit,
                    label: 'Editar',
                    color: const Color(0xFF4A2C1A),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditMemberPage(
                            userId: userId,
                            name: name,
                            email: email,
                            role: role,
                            image: image,
                          ),
                        ),
                      ).then((result) {
                        if (result == true) {
                          ref.read(teamStateProvider.notifier).loadTeamUsers();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Botón Eliminar
                Expanded(
                  child: _ActionButton(
                    icon: Icons.delete,
                    label: 'Eliminar',
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Usuario'),
                          content: Text('¿Estás seguro de que deseas eliminar a $name?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                try {
                                  await ref
                                      .read(teamStateProvider.notifier)
                                      .deleteTeamUser(userId);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Usuario eliminado correctamente'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString().replaceAll('Exception: ', ''),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Botón Chat
                Expanded(
                  child: _ActionButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    color: const Color(0xFF4A2C1A),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PrivateChatPage(
                            otherUserId: userId,
                            otherUserName: name,
                            otherUserImage: image,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDelete = color == Colors.red;
    
    return Material(
      color: isDelete ? color : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDelete ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDelete ? color : color.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isDelete ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDelete ? Colors.white : color,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFF5F1E8) // Beige claro
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF4A2C1A) // Marrรณn oscuro
                  : const Color(0xFF5A5A5A), // Gris oscuro
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: label.length > 12 ? 9 : 11,
                  color: isActive
                      ? const Color(0xFF4A2C1A) // Marrรณn oscuro
                      : const Color(0xFF5A5A5A), // Gris oscuro
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

