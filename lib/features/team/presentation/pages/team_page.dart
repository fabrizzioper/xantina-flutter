import 'package:flutter/material.dart';
import 'edit_member_page.dart';
import '../../../business/presentation/pages/my_businesses_page.dart';
import '../../../alerts/presentation/pages/alerts_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  int _currentIndex = 0; // Team ya no está en el bottom nav

  // Datos de ejemplo
  final List<Map<String, String>> _teamMembers = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'Barista',
      'status': 'Active',
    },
    {
      'name': 'Maria Alvarez',
      'email': 'maria.alvarez@coffeecorner.com',
      'role': 'Senior Barista',
      'status': 'Active',
    },
    {
      'name': 'Leo Martinez',
      'email': 'leo.m@brewhouse.co',
      'role': 'Barista',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
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
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _teamMembers.length,
        itemBuilder: (context, index) {
          final member = _teamMembers[index];
          return _TeamMemberCard(
            name: member['name']!,
            email: member['email']!,
            role: member['role']!,
            status: member['status']!,
            onRemove: () {
              // TODO: Implementar lógica de eliminación
            },
            onEdit: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditMemberPage(
                    name: member['name']!,
                    email: member['email']!,
                    role: member['role']!,
                    status: member['status']!,
                  ),
                ),
              );
            },
            onChat: () {
              // TODO: Implementar lógica de chat
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar lógica para agregar miembro
        },
        backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
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
}

class _TeamMemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String status;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  final VoidCallback onChat;

  const _TeamMemberCard({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.onRemove,
    required this.onEdit,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
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
          // Foto de perfil - Centrada y más pequeña
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4A2C1A), // Marrón oscuro
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 28,
            ),
          ),
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
          const SizedBox(height: 16),
          // Rol y Estado - Centrados y en columnas
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Rol: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A3A5F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Estado: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  Text(
                    status == 'Active' ? 'Activo' : status,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Botones - Responsive con Wrap
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: onRemove,
                child: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Color(0xFF5A5A5A), // Gris oscuro
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Editar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                  ? const Color(0xFF4A2C1A) // Marrón oscuro
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
                      ? const Color(0xFF4A2C1A) // Marrón oscuro
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

