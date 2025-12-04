import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../business/presentation/pages/my_businesses_page.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  int _currentIndex = 1; // Actualizaciones está activo
  String _selectedFilter = 'Todas'; // Todas, Leídas, No leídas

  // Datos de ejemplo
  final List<Map<String, dynamic>> _todayAlerts = [
    {
      'title': '¡Alerta de Lote Nuevo!',
      'description':
          'Lorem Ipsum tempor incididunt ut labore et dolore, in voluptate velit esse cillum',
      'timestamp': 'Hace 10 min',
      'isRead': false,
    },
    {
      'title': '¡Alerta de Guardar Lote!',
      'description':
          'Lorem Ipsum tempor incididunt ut labore et dolore, in voluptate velit esse cillum',
      'timestamp': 'Hace 30 min',
      'isRead': false,
    },
    {
      'title': '¡Alerta de Lote Nuevo!',
      'description':
          'Lorem Ipsum tempor incididunt ut labore et dolore, in voluptate velit esse cillum',
      'timestamp': 'Hace 1 hora',
      'isRead': true,
    },
  ];

  final List<Map<String, dynamic>> _yesterdayAlerts = [
    {
      'title': 'Ajuste de Receta: Mezcla Espresso',
      'description':
          'Lorem Ipsum tempor incididunt ut labore et dolore, in voluptate velit esse cillum',
      'timestamp': 'Hace 10 min',
      'isRead': true,
    },
    {
      'title': 'Ajuste de Receta: Prensa Francesa',
      'description':
          'Lorem Ipsum tempor incididunt ut labore et dolore, in voluptate velit esse cillum',
      'timestamp': 'Hace 30 min',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> _getFilteredAlerts(List<Map<String, dynamic>> alerts) {
    if (_selectedFilter == 'Todas') {
      return alerts;
    } else if (_selectedFilter == 'Leídas') {
      return alerts.where((alert) => alert['isRead'] == true).toList();
    } else {
      return alerts.where((alert) => alert['isRead'] == false).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTodayAlerts = _getFilteredAlerts(_todayAlerts);
    final filteredYesterdayAlerts = _getFilteredAlerts(_yesterdayAlerts);

    return Scaffold(
      backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
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
          'Alertas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FilterButton(
                  label: 'Todas',
                  isSelected: _selectedFilter == 'Todas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Todas';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _FilterButton(
                  label: 'Leídas',
                  isSelected: _selectedFilter == 'Leídas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'Leídas';
                    });
                  },
                ),
                const SizedBox(width: 16),
                _FilterButton(
                  label: 'No leídas',
                  isSelected: _selectedFilter == 'No leídas',
                  onTap: () {
                    setState(() {
                      _selectedFilter = 'No leídas';
                    });
                  },
                ),
              ],
            ),
          ),
          // Lista de alertas
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                if (filteredTodayAlerts.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Hoy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...filteredTodayAlerts.map((alert) => _AlertCard(
                        title: alert['title'] as String,
                        description: alert['description'] as String,
                        timestamp: alert['timestamp'] as String,
                        isRead: alert['isRead'] as bool,
                      )),
                ],
                if (filteredYesterdayAlerts.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Ayer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...filteredYesterdayAlerts.map((alert) => _AlertCard(
                        title: alert['title'] as String,
                        description: alert['description'] as String,
                        timestamp: alert['timestamp'] as String,
                        isRead: alert['isRead'] as bool,
                      )),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
              ),
              _BottomNavItem(
                icon: Icons.notifications,
                label: 'Actualizaciones',
                isActive: _currentIndex == 1,
                onTap: () {
                  // Ya estamos en Actualizaciones
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

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white // Blanco cuando está seleccionado
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF4A2C1A) // Marrón oscuro cuando está seleccionado
                : Colors.white, // Blanco cuando no está seleccionado
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;
  final bool isRead;

  const _AlertCard({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Blanco
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A5A5A), // Gris oscuro
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E), // Gris claro
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Icono con punto de notificación
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFA726), // Naranja/amarillo claro
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (!isRead)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6F00), // Naranja más oscuro
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
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

