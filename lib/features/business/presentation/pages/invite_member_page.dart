import 'package:flutter/material.dart';

class InviteMemberPage extends StatefulWidget {
  final String businessName;

  const InviteMemberPage({
    super.key,
    required this.businessName,
  });

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedUserId;
  String? _selectedRole;
  List<Map<String, String>> _filteredUsers = [];

  // Datos mockeados de usuarios
  final List<Map<String, String>> _mockUsers = [
    {
      'id': '1',
      'name': 'Juan Pérez',
      'email': 'juan.perez@example.com',
    },
    {
      'id': '2',
      'name': 'María García',
      'email': 'maria.garcia@example.com',
    },
    {
      'id': '3',
      'name': 'Carlos Rodríguez',
      'email': 'carlos.rodriguez@example.com',
    },
    {
      'id': '4',
      'name': 'Ana Martínez',
      'email': 'ana.martinez@example.com',
    },
    {
      'id': '5',
      'name': 'Luis Fernández',
      'email': 'luis.fernandez@example.com',
    },
    {
      'id': '6',
      'name': 'Sofía López',
      'email': 'sofia.lopez@example.com',
    },
  ];

  final List<String> _roles = [
    'Barista',
    'Senior Barista',
    'Gerente',
    'Cajero',
    'Mesero',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = [];
      } else {
        _filteredUsers = _mockUsers
            .where((user) =>
                user['name']!.toLowerCase().contains(query) ||
                user['email']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Beige claro
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
          'Invitar a un nuevo miembro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Buscador de usuarios
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o correo...',
                hintStyle: const TextStyle(
                  color: Color(0xFF5A5A5A), // Gris oscuro
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF5A5A5A),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0), // Gris claro
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0), // Gris claro
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4A2C1A), // Marrón oscuro cuando está enfocado
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de usuarios filtrados
            if (_filteredUsers.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    final isSelected = _selectedUserId == user['id'];
                    return ListTile(
                      title: Text(
                        user['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A3A5F), // Azul oscuro
                        ),
                      ),
                      subtitle: Text(
                        user['email']!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A5A5A), // Gris oscuro
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: Color(0xFF4A2C1A), // Marrón oscuro
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedUserId = user['id'];
                        });
                      },
                    );
                  },
                ),
              ),
            // Usuario seleccionado
            if (_selectedUserId != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4A2C1A), // Marrón oscuro
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A2C1A), // Marrón oscuro
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _mockUsers.firstWhere(
                              (u) => u['id'] == _selectedUserId,
                            )['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A3A5F), // Azul oscuro
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _mockUsers.firstWhere(
                              (u) => u['id'] == _selectedUserId,
                            )['email']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A5A5A), // Gris oscuro
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Selector de rol
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Rol',
                labelStyle: const TextStyle(
                  color: Color(0xFF5A5A5A), // Gris oscuro
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0), // Gris claro
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0), // Gris claro
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4A2C1A), // Marrón oscuro cuando está enfocado
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 32),
            // Botón de enviar invitación
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_selectedUserId != null && _selectedRole != null)
                    ? () {
                        // TODO: Implementar lógica de envío de invitación
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE0E0E0), // Gris claro
                  disabledForegroundColor: const Color(0xFF5A5A5A), // Gris oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Enviar Invitación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

