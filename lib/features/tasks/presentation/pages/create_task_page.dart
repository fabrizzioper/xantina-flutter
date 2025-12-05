import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/utils/image_helpers.dart';
import '../../../../core/utils/helpers.dart';
import '../../../business/presentation/providers/business_provider.dart';
import '../../../business/presentation/providers/business_member_provider.dart';
import '../../../business/domain/entities/business.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';
import '../../infra/datasources/task_api.dart';
import '../../domain/repositories/task_repository.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedBusinessId;
  String? _selectedMemberId;
  List<XFile> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Cargar negocios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessStateProvider.notifier).loadBusinesses();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imágenes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _createTask() async {
    final authState = ref.read(authStateProvider);
    final user = authState.authResponse?.user;
    
    // Verificar que el usuario es admin
    if (user?.role != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo los administradores pueden crear tareas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _selectedBusinessId == null ||
        _selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Convertir imágenes a base64
      final List<String> imageBase64List = [];
      for (final image in _selectedImages) {
        final base64 = await Helpers.imageToBase64(image);
        final formatted = Helpers.formatBase64Image(base64);
        if (formatted != null) {
          imageBase64List.add(formatted);
        }
      }

      // Crear la tarea
      final taskRepository = TaskApi();
      await taskRepository.createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        businessId: _selectedBusinessId!,
        assignedToUserId: _selectedMemberId!,
        images: imageBase64List.isNotEmpty ? imageBase64List : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea creada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessStateProvider);
    final businessMemberState = _selectedBusinessId != null
        ? ref.watch(businessMemberStateProvider(_selectedBusinessId!))
        : null;

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
          'Crear Tarea',
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
            // Campo de título
            _CustomTextField(
              controller: _titleController,
              label: 'Título',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            // Campo de descripción
            _CustomTextField(
              controller: _descriptionController,
              label: 'Descripción',
              keyboardType: TextInputType.multiline,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            // Selector de negocio
            DropdownButtonFormField<String>(
              value: _selectedBusinessId,
              decoration: InputDecoration(
                labelText: 'Negocio',
                labelStyle: const TextStyle(
                  color: Color(0xFF5A5A5A),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
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
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'Seleccionar negocio',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                ...businessState.businesses.map((business) {
                  return DropdownMenuItem<String>(
                    value: business.id,
                    child: Text(business.name),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedBusinessId = value;
                  _selectedMemberId = null; // Resetear miembro al cambiar negocio
                });
                // Cargar miembros del negocio seleccionado
                if (value != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(businessMemberStateProvider(value).notifier)
                        .loadMembers(value);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            // Selector para asignar a miembro del equipo
            DropdownButtonFormField<String>(
              value: _selectedMemberId,
              decoration: InputDecoration(
                labelText: 'Asignar a',
                labelStyle: const TextStyle(
                  color: Color(0xFF5A5A5A),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4A2C1A),
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'Seleccionar miembro del equipo',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ),
                if (businessMemberState != null)
                  ...businessMemberState.members.map((member) {
                    return DropdownMenuItem<String>(
                      value: member.id,
                      child: Text(member.name ?? member.email ?? 'Usuario'),
                    );
                  }).toList(),
              ],
              onChanged: (_selectedBusinessId != null &&
                      businessMemberState != null &&
                      businessMemberState.members.isNotEmpty)
                  ? (value) {
                      setState(() {
                        _selectedMemberId = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            // Sección de imágenes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Imágenes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A2C1A),
                  ),
                ),
                const SizedBox(height: 8),
                // Botón para agregar imágenes
                OutlinedButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Agregar imágenes'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A2C1A)),
                    foregroundColor: const Color(0xFF4A2C1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Grid de imágenes seleccionadas
                if (_selectedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImages[index].path),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),
            // Botón de crear
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_titleController.text.trim().isNotEmpty &&
                        _descriptionController.text.trim().isNotEmpty &&
                        _selectedBusinessId != null &&
                        _selectedMemberId != null)
                    ? _createTask
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  disabledForegroundColor: const Color(0xFF5A5A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Crear Tarea',
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

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int? maxLines;

  const _CustomTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }
}

