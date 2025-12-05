import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/helpers.dart';
import '../providers/team_provider.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});

  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _showPassword = false;
  XFile? _selectedImage;
  String? _imageBase64;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Agregar Usuario',
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
            // Foto de perfil obligatoria
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedImage == null
                        ? Colors.red.shade300
                        : const Color(0xFF4A2C1A),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          File(_selectedImage!.path),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF4A2C1A),
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Foto de perfil',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5A5A5A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '* Obligatorio',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para seleccionar una foto',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (_selectedImage == null) ...[
              const SizedBox(height: 4),
              Text(
                '* La foto de perfil es obligatoria',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 32),
            // Campo de nombre
            _CustomTextField(
              controller: _nameController,
              label: 'Nombre *',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            // Campo de email
            _CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico *',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Campo de contraseña
            _CustomTextField(
              controller: _passwordController,
              label: 'Contraseña *',
              obscureText: !_showPassword,
              showPasswordToggle: true,
              onTogglePassword: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleCreateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: ref.watch(teamStateProvider).isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Crear Usuario',
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

  Future<void> _selectImage() async {
    try {
      // Mostrar opciones: Cámara o Galería
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de la galería'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (image != null) {
        // Verificar tamaño del archivo (máximo 2MB antes de base64)
        final file = File(image.path);
        final fileSize = await file.length();
        const maxSizeInBytes = 2 * 1024 * 1024; // 2MB
        
        if (fileSize > maxSizeInBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'La imagen es muy grande. Por favor elige una imagen más pequeña.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        final base64Image = await Helpers.imageToBase64(image);
        if (base64Image != null) {
          final formattedBase64 = Helpers.formatBase64Image(base64Image);
          
          // Verificar tamaño del base64 (máximo 8MB)
          if (formattedBase64 != null && formattedBase64.length > 8 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'La imagen es muy grande después de procesarla. Por favor elige una imagen más pequeña.',
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }

          setState(() {
            _selectedImage = image;
            _imageBase64 = formattedBase64;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCreateUser() async {
    // Validar que la imagen sea obligatoria
    if (_selectedImage == null || _imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una foto de perfil'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar que todos los campos estén completos
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar formato de email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un email válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar longitud de contraseña
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(teamStateProvider.notifier).createTeamUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            image: _imageBase64!,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final VoidCallback? onTogglePassword;

  const _CustomTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5A5A5A)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A2C1A), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: showPasswordToggle
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF5A5A5A),
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
    );
  }
}
