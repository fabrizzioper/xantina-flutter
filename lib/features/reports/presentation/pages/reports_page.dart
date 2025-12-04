import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../business/presentation/pages/my_businesses_page.dart';
import '../../../alerts/presentation/pages/alerts_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = '24 hrs usage';
  int _currentIndex = 0;

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
          'Reportes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card principal blanco
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee Used in Last 24 Hours
                  const Text(
                    'Café usado en las últimas 24 hrs',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '1.13kg',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '↑ + 12%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Reduction in Daily Usage
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A2C1A), // Marrón oscuro
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '340g ahorrados de desperdicio',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Circular Progress Chart
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Círculo de fondo
                              SizedBox(
                                width: 180,
                                height: 180,
                                child: CircularProgressIndicator(
                                  value: 0.8,
                                  strokeWidth: 20,
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4A2C1A),
                                  ),
                                ),
                              ),
                              // Texto en el centro
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '80%',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Recetas aprobadas\nusadas',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5A5A5A),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Usage by Origin and Time of Day - Side by side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Uso por origen',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _OriginItem(
                              color: const Color(0xFF4A2C1A),
                              origin: 'Guatemala',
                              quantity: '123g',
                            ),
                            const SizedBox(height: 8),
                            _OriginItem(
                              color: const Color(0xFF6B4423),
                              origin: 'Etiopía',
                              quantity: '105g',
                            ),
                            const SizedBox(height: 8),
                            _OriginItem(
                              color: const Color(0xFF8B5A3C),
                              origin: 'Colombia',
                              quantity: '104g',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Uso por hora del día',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _OriginItem(
                              color: Colors.black,
                              origin: 'Mañana',
                              quantity: '400g',
                            ),
                            const SizedBox(height: 8),
                            _OriginItem(
                              color: const Color(0xFF9E9E9E),
                              origin: 'Tarde',
                              quantity: '200g',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Selector de período
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PeriodButton(
                    label: '24 hrs uso',
                    isSelected: _selectedPeriod == '24 hrs usage',
                    onTap: () {
                      setState(() {
                        _selectedPeriod = '24 hrs usage';
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _PeriodButton(
                    label: 'Uso semanal',
                    isSelected: _selectedPeriod == 'week usage',
                    onTap: () {
                      setState(() {
                        _selectedPeriod = 'week usage';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlertsPage(),
                    ),
                  );
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


class _OriginItem extends StatelessWidget {
  final Color color;
  final String origin;
  final String quantity;

  const _OriginItem({
    required this.color,
    required this.origin,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$origin - $quantity',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFF9E9E9E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 16,
              ),
            if (isSelected) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
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

