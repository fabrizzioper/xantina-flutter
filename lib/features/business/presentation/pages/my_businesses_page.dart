import 'package:flutter/material.dart';
import 'create_business_page.dart';
import 'business_details_page.dart';

class MyBusinessesPage extends StatefulWidget {
  const MyBusinessesPage({super.key});

  @override
  State<MyBusinessesPage> createState() => _MyBusinessesPageState();
}

class _MyBusinessesPageState extends State<MyBusinessesPage> {
  int _currentIndex = 3; // Negocio está activo

  // Lista de negocios de ejemplo
  final List<Map<String, String>> _businesses = [
    {
      'name': 'Maná Coffe',
      'address': 'Calle Principal 123',
      'phone': '987654321',
    },
  ];

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
          'Mis Negocios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateBusinessPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
        child: const Icon(
          Icons.add_business,
          color: Colors.white,
        ),
      ),
      body: _businesses.isEmpty
          ? _EmptyBusinessesView(
              onCreateBusiness: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateBusinessPage(),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: _businesses.length,
              itemBuilder: (context, index) {
                final business = _businesses[index];
                return _BusinessCard(
                  name: business['name']!,
                  address: business['address']!,
                  phone: business['phone']!,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BusinessDetailsPage(
                          businessName: business['name']!,
                        ),
                      ),
                    );
                  },
                );
              },
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
        padding: const EdgeInsets.only(bottom: 6),
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              _BottomNavItem(
                icon: Icons.people,
                label: 'Equipo',
                isActive: _currentIndex == 1,
                onTap: () {
                  // TODO: Navegar a Team
                },
              ),
              _BottomNavItem(
                icon: Icons.notifications,
                label: 'Actualizaciones',
                isActive: _currentIndex == 2,
                onTap: () {
                  // TODO: Navegar a Updates
                },
              ),
              _BottomNavItem(
                icon: Icons.business,
                label: 'Negocio',
                isActive: _currentIndex == 3,
                onTap: () {
                  // Ya estamos en Negocio
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBusinessesView extends StatelessWidget {
  final VoidCallback onCreateBusiness;

  const _EmptyBusinessesView({
    required this.onCreateBusiness,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF4A2C1A), // Marrón oscuro
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No tienes negocios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3A5F), // Azul oscuro
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Crea tu primer negocio para comenzar',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF5A5A5A), // Gris oscuro
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onCreateBusiness,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_business,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Crear mi Primer Negocio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final VoidCallback onTap;

  const _BusinessCard({
    required this.name,
    required this.address,
    required this.phone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A2C1A), // Marrón oscuro
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Maná',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5F1E8), // Beige claro
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A5F), // Azul oscuro
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF5A5A5A),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5A5A5A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 14,
                color: Color(0xFF5A5A5A),
              ),
              const SizedBox(width: 4),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A5A5A),
                ),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

