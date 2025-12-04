import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/image_helpers.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authStateProvider);
    final user = authState.authResponse?.user;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController();
    _roleController = TextEditingController(text: user?.role ?? 'user');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.authResponse?.user;

    // Actualizar controllers si el usuario cambia
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _roleController.text = user.role;
    }

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
          'Editar Mi Perfil',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Foto de perfil
            ImageHelpers.buildBase64Image(user?.image, size: 100),
            const SizedBox(height: 16),
            // Nombre
            Text(
              user?.name ?? 'Usuario',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3A5F),
              ),
            ),
            const SizedBox(height: 8),
            // Username (email sin dominio)
            Text(
              user?.email != null ? '@${user!.email.split('@')[0]}' : '@usuario',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5A5A5A),
              ),
            ),
            const SizedBox(height: 24),
            // Divider con información
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF5A5A5A),
                ),
                const SizedBox(width: 6),
                const Text(
                  '20 Nov 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  width: 1,
                  height: 20,
                  color: const Color(0xFFE0E0E0),
                ),
                const SizedBox(width: 24),
                const Icon(
                  Icons.work,
                  size: 16,
                  color: Color(0xFF5A5A5A),
                ),
                const SizedBox(width: 6),
                Text(
                  'Rol: ${user?.role ?? 'user'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Campo de nombre
            _EditField(
              label: 'Nombre:',
              controller: _nameController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            // Campos de información
            _EditField(
              label: 'Email:',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _EditField(
              label: 'Número de teléfono:',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              hintText: '987654321',
            ),
            const SizedBox(height: 32),
            // Botón de editar rol y permisos (solo para admin)
            if (user?.role == 'admin') ...[
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar lógica de edición de rol y permisos
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A5A5A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Editar Rol y Permisos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Guardar cambios
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Guardar Cambios',
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

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hintText;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A5F), // Azul oscuro
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
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
                color: Color(0xFF4A2C1A), // Marrón oscuro
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

