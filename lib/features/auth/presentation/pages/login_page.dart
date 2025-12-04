import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para Login
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Controllers para Registro
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoginTab = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _showLoginPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Beige claro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo - Imagen de taza de café
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4A2C1A), // Marrón oscuro
                    width: 3,
                  ),
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/coffe-logo-removebg-preview.png',
                    width: 114,
                    height: 114,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Título y badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Xantina',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A5F), // Azul oscuro
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A2C1A), // Marrón oscuro
                      borderRadius: BorderRadius.circular(20), // Más ovalado
                    ),
                    child: const Text(
                      'for Owners',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tagline
              const Text(
                'Tu compañera de café de especialidad',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5A5A5A), // Gris oscuro
                ),
              ),
              const SizedBox(height: 40),
              // Tabs
              Row(
                children: [
                  Expanded(
                    child: _TabButton(
                      text: 'Iniciar Sesión',
                      isActive: _isLoginTab,
                      onTap: () {
                        setState(() {
                          _isLoginTab = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TabButton(
                      text: 'Registrate',
                      isActive: !_isLoginTab,
                      onTap: () {
                        setState(() {
                          _isLoginTab = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Formularios según el tab activo
              if (_isLoginTab) ...[
                // Formulario de Login
                _CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: !_showLoginPassword,
                  showPasswordToggle: true,
                  onTogglePassword: () {
                    setState(() {
                      _showLoginPassword = !_showLoginPassword;
                    });
                  },
                ),
                const SizedBox(height: 32),
                // Botón de Login
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar lógica de login
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
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Formulario de Registro
                _CustomTextField(
                  controller: _nameController,
                  label: 'Nombre',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: _usernameController,
                  label: 'Usuario',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: _registerEmailController,
                  label: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: _registerPasswordController,
                  label: 'Contraseña',
                  obscureText: !_showPassword,
                  showPasswordToggle: true,
                  onTogglePassword: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar contraseña',
                  obscureText: !_showConfirmPassword,
                  showPasswordToggle: true,
                  onTogglePassword: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 32),
                // Botón de Registro
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar lógica de registro
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
                      'Registrarse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF4A2C1A) // Marrón oscuro cuando está activo
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : const Color(0xFF5A5A5A), // Gris oscuro cuando está inactivo
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
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
        suffixIcon: showPasswordToggle
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: const Color(0xFF5A5A5A),
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
    );
  }
}

