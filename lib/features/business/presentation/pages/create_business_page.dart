import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/helpers.dart';
import '../providers/business_provider.dart';

class CreateBusinessPage extends ConsumerStatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  ConsumerState<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends ConsumerState<CreateBusinessPage> {
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  XFile? _selectedImage;
  String? _logoBase64;

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _typeController.dispose();
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
          'Crear Negocio',
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
            // Logo del negocio
            Center(
              child: GestureDetector(
                onTap: _selectLogo,
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
                              'Logo',
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
            ),
            const SizedBox(height: 8),
            Text(
              'Toca para seleccionar un logo',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedImage == null) ...[
              const SizedBox(height: 4),
              Text(
                '* El logo es obligatorio',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            // Campos del negocio
            _CustomTextField(
              controller: _businessNameController,
              label: 'Nombre del Negocio',
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _typeController,
              label: 'Tipo',
              keyboardType: TextInputType.text,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _phoneController,
              label: 'Teléfono',
              keyboardType: TextInputType.phone,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _addressController,
              label: 'Dirección',
              keyboardType: TextInputType.streetAddress,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _descriptionController,
              label: 'Descripción',
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              isRequired: true,
            ),
            const SizedBox(height: 32),
            // Botón de crear
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleCreateBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: ref.watch(businessStateProvider).isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Crear Negocio',
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

  Future<void> _handleCreateBusiness() async {
    // Validar que el logo sea obligatorio
    if (_selectedImage == null || _logoBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un logo para el negocio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar todos los campos requeridos
    if (_businessNameController.text.trim().isEmpty ||
        _typeController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ref.read(businessStateProvider.notifier).createBusiness(
            name: _businessNameController.text.trim(),
            type: _typeController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            description: _descriptionController.text.trim(),
            logo: _logoBase64!,
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
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

  Future<void> _selectLogo() async {
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

        setState(() {
          _selectedImage = image;
        });

        final base64 = await Helpers.imageToBase64(image);
        if (base64 != null) {
          if (base64.length > 8 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'La imagen es muy grande incluso después de comprimir. Por favor elige otra imagen.',
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            setState(() {
              _selectedImage = null;
              _logoBase64 = null;
            });
            return;
          }
          
          setState(() {
            _logoBase64 = Helpers.formatBase64Image(base64);
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
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRequired;

  const _CustomTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        labelStyle: TextStyle(
          color: isRequired ? Colors.red.shade700 : const Color(0xFF5A5A5A),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isRequired ? Colors.red.shade300 : const Color(0xFFE0E0E0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isRequired ? Colors.red.shade300 : const Color(0xFFE0E0E0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isRequired ? Colors.red.shade700 : const Color(0xFF4A2C1A),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
