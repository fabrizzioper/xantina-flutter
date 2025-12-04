import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedMember;

  // Datos de ejemplo del equipo
  final List<Map<String, String>> _teamMembers = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    },
    {
      'name': 'Maria Alvarez',
      'email': 'maria.alvarez@coffeecorner.com',
    },
    {
      'name': 'Leo Martinez',
      'email': 'leo.m@brewhouse.co',
    },
    {
      'name': 'Bella Throne',
      'email': 'bella.throne@example.com',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
            // Selector para asignar a miembro del equipo
            DropdownButtonFormField<String>(
              value: _selectedMember,
              decoration: InputDecoration(
                labelText: 'Asignar a',
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
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    'Seleccionar miembro del equipo',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E), // Gris claro
                    ),
                  ),
                ),
                ..._teamMembers.map((member) {
                  return DropdownMenuItem<String>(
                    value: member['email'],
                    child: Text(member['name']!),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMember = value;
                });
              },
            ),
            const SizedBox(height: 32),
            // Botón de crear
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (_titleController.text.trim().isNotEmpty &&
                        _descriptionController.text.trim().isNotEmpty &&
                        _selectedMember != null)
                    ? () {
                        // TODO: Implementar lógica de creación de tarea
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

