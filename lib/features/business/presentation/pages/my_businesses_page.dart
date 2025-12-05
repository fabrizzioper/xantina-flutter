import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_business_page.dart';
import 'business_details_page.dart';
import '../../../alerts/presentation/pages/alerts_page.dart';
import '../../../../core/utils/image_helpers.dart';
import '../providers/business_provider.dart';
import '../../../user-auth/presentation/providers/user_auth_provider.dart';

class MyBusinessesPage extends ConsumerStatefulWidget {
  const MyBusinessesPage({super.key});

  @override
  ConsumerState<MyBusinessesPage> createState() => _MyBusinessesPageState();
}

class _MyBusinessesPageState extends ConsumerState<MyBusinessesPage> {
  int _currentIndex = 2; // Negocio está activo

  @override
  void initState() {
    super.initState();
    // Cargar negocios cuando se inicia la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessStateProvider.notifier).loadBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessState = ref.watch(businessStateProvider);
    final businesses = businessState.businesses;
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
      floatingActionButton: ref.watch(authStateProvider).authResponse?.user.role == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateBusinessPage(),
                  ),
                );
                
                // Si se creó un negocio exitosamente, recargar la lista
                if (result == true) {
                  ref.read(businessStateProvider.notifier).loadBusinesses();
                }
              },
              backgroundColor: const Color(0xFF4A2C1A), // Marrón oscuro
              child: const Icon(
                Icons.add_business,
                color: Colors.white,
              ),
            )
          : null,
      body: businessState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A2C1A),
              ),
            )
          : businessState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${businessState.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(businessStateProvider.notifier).loadBusinesses();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : businesses.isEmpty
                  ? const _EmptyBusinessesView()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(businessStateProvider.notifier).loadBusinesses();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24.0),
                        itemCount: businesses.length,
                        itemBuilder: (context, index) {
                          final business = businesses[index];
                          return _BusinessCard(
                            name: business.name,
                            address: business.address,
                            phone: business.phone,
                            logo: business.logo,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BusinessDetailsPage(
                                    businessId: business.id,
                                    businessName: business.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
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

class _EmptyBusinessesView extends ConsumerWidget {
  const _EmptyBusinessesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authStateProvider).authResponse?.user.role == 'admin';
    
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
            Text(
              isAdmin
                  ? 'No tienes negocios'
                  : 'No perteneces a ningún negocio',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3A5F), // Azul oscuro
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAdmin
                  ? 'Usa el botón + para crear tu primer negocio'
                  : 'Pide a tu administrador que te agregue a un negocio',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5A5A5A), // Gris oscuro
              ),
              textAlign: TextAlign.center,
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
  final String? logo;
  final VoidCallback onTap;

  const _BusinessCard({
    required this.name,
    required this.address,
    required this.phone,
    this.logo,
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
              ImageHelpers.buildBusinessLogo(logo, size: 60),
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

