import 'package:flutter/material.dart';

class CreateBusinessPage extends StatefulWidget {
  const CreateBusinessPage({super.key});

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _typeController = TextEditingController();

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
                onTap: () {
                  // TODO: Implementar selección de logo
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4A2C1A), // Marrón oscuro
                      width: 2,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
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
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Campos del negocio
            _CustomTextField(
              controller: _businessNameController,
              label: 'Nombre del Negocio',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _typeController,
              label: 'Tipo',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _phoneController,
              label: 'Teléfono',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _addressController,
              label: 'Dirección',
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 16),
            _CustomTextField(
              controller: _descriptionController,
              label: 'Descripción',
              keyboardType: TextInputType.multiline,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            // Botón de crear
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementar lógica de creación
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

