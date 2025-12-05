import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/image_helpers.dart';
import '../../../../core/utils/helpers.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final ImagePicker _imagePicker = ImagePicker();
  
  XFile? _selectedImage;
  String? _newImageBase64;
  String? _originalEmail;
  bool _emailChanged = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authStateProvider);
    final user = authState.authResponse?.user;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _originalEmail = user?.email;
    
    // Listener para detectar cambios en el email
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    if (_emailController.text.trim() != _originalEmail) {
      if (!_emailChanged) {
        setState(() {
          _emailChanged = true;
        });
      }
    } else {
      if (_emailChanged) {
        setState(() {
          _emailChanged = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.authResponse?.user;
    final isUser = user?.role == 'user';
    final isLoading = authState.isLoading;

    // Si es usuario tipo 'user', mostrar solo lectura
    if (isUser) {
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
            'Mi Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Color(0xFF5A5A5A),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No tienes permisos para editar tu perfil',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5A5A5A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Mostrar imagen seleccionada o la imagen actual
    final displayImage = _selectedImage != null
        ? File(_selectedImage!.path)
        : null;
    final displayImageBase64 = _selectedImage != null
        ? null
        : user?.image;

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
            // Foto de perfil editable
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4A2C1A),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: displayImage != null
                    ? ClipOval(
                        child: Image.file(
                          displayImage,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : displayImageBase64 != null
                        ? ImageHelpers.buildBase64Image(
                            displayImageBase64,
                            size: 120,
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Color(0xFF4A2C1A),
                                size: 32,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Foto',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF5A5A5A),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para cambiar la foto',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            // Campo de nombre
            _EditField(
              label: 'Nombre:',
              controller: _nameController,
              keyboardType: TextInputType.text,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            // Campo de email
            _EditField(
              label: 'Email:',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
            ),
            if (_emailChanged) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Si cambias el email, se cerrará tu sesión automáticamente',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            // Botón de Guardar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Guardar',
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
            _newImageBase64 = formattedBase64;
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

  Future<void> _handleSave() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = ref.read(authStateProvider);
    final user = authState.authResponse?.user;
    
    if (user == null) return;

    final emailChanged = _emailController.text.trim() != _originalEmail;

    // Si cambió el email, mostrar confirmación
    if (emailChanged) {
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cambiar Email'),
          content: const Text(
            'Si cambias tu email, se cerrará tu sesión automáticamente y tendrás que iniciar sesión nuevamente con tu nuevo email.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A2C1A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        return;
      }
    }

    try {
      await ref.read(authStateProvider.notifier).updateProfile(
            name: _nameController.text.trim() != user.name
                ? _nameController.text.trim()
                : null,
            email: emailChanged ? _emailController.text.trim() : null,
            image: _newImageBase64,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Si cambió el email, cerrar sesión
        if (emailChanged) {
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            await ref.read(authStateProvider.notifier).logout();
            
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Email cambiado. Por favor inicia sesión con tu nuevo email.',
                  ),
                  backgroundColor: Colors.blue,
                  duration: Duration(seconds: 4),
                ),
              );
            }
          }
        } else {
          // Si no cambió el email, solo cerrar la página
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar perfil: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool enabled;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.enabled = true,
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
            color: Color(0xFF1A3A5F),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
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
              borderSide: const BorderSide(
                color: Color(0xFF4A2C1A),
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
