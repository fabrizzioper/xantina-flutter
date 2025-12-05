import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../team/presentation/providers/team_provider.dart';
import '../../../../core/utils/image_helpers.dart';
import '../providers/business_member_provider.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';

class AddMembersPage extends ConsumerStatefulWidget {
  final String businessId;
  final String businessName;

  const AddMembersPage({
    super.key,
    required this.businessId,
    required this.businessName,
  });

  @override
  ConsumerState<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends ConsumerState<AddMembersPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    // Cargar usuarios del equipo y miembros actuales del negocio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamStateProvider.notifier).loadTeamUsers();
      ref.read(businessMemberStateProvider(widget.businessId).notifier).loadMembers(widget.businessId);
    });
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppUser> _getFilteredUsers(List<AppUser> users, Set<String> excludeIds) {
    // Filtrar usuarios que ya son miembros del negocio
    final availableUsers = users.where((user) => !excludeIds.contains(user.id)).toList();
    
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return availableUsers; // Mostrar todos los disponibles cuando no hay búsqueda
    }
    return availableUsers.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamStateProvider);
    final users = teamState.users;
    final isLoading = teamState.isLoading;
    
    // Obtener miembros actuales del negocio para excluirlos de la lista
    final memberState = ref.watch(businessMemberStateProvider(widget.businessId));
    final currentMembers = memberState.members;
    final currentMemberIds = currentMembers.map((m) => m.id).toSet();
    
    final filteredUsers = _getFilteredUsers(users, currentMemberIds);

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
          'Agregar Miembros',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o correo...',
                hintStyle: const TextStyle(
                  color: Color(0xFF5A5A5A),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF5A5A5A),
                ),
                filled: true,
                fillColor: Colors.white,
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
          ),
          // Lista de usuarios
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4A2C1A),
                    ),
                  )
                    : users.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: Color(0xFF5A5A5A),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No tienes usuarios en tu equipo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF5A5A5A),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filteredUsers.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        currentMemberIds.length >= users.length
                                            ? Icons.check_circle_outline
                                            : Icons.search_off,
                                        size: 64,
                                        color: currentMemberIds.length >= users.length
                                            ? Colors.green[600]
                                            : const Color(0xFF5A5A5A),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        currentMemberIds.length >= users.length
                                            ? 'Todos tus usuarios ya están agregados a este negocio'
                                            : 'No se encontraron usuarios disponibles',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: currentMemberIds.length >= users.length
                                              ? Colors.green[700]
                                              : const Color(0xFF5A5A5A),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24.0),
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  final isSelected =
                                      _selectedUserIds.contains(user.id);
                                  return _UserCheckboxCard(
                                    user: user,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedUserIds.remove(user.id);
                                        } else {
                                          _selectedUserIds.add(user.id);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
          ),
          // Botón de agregar
          if (_selectedUserIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleAddMembers,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A2C1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Agregar (${_selectedUserIds.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleAddMembers() async {
    if (_selectedUserIds.isEmpty) return;

    // Mostrar checklist antes de continuar
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text(
          '¿Deseas agregar ${_selectedUserIds.length} miembro${_selectedUserIds.length > 1 ? 's' : ''} a este negocio?',
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
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (shouldContinue == true && mounted) {
      try {
        await ref.read(businessMemberStateProvider(widget.businessId).notifier).addMembers(
              businessId: widget.businessId,
              userIds: _selectedUserIds.toList(),
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${_selectedUserIds.length} miembro${_selectedUserIds.length > 1 ? 's' : ''} agregado${_selectedUserIds.length > 1 ? 's' : ''} correctamente',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().replaceAll('Exception: ', ''),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class _UserCheckboxCard extends StatelessWidget {
  final AppUser user;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserCheckboxCard({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A2C1A)
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ImageHelpers.buildBase64Image(user.image, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A3A5F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF4A2C1A),
            ),
          ],
        ),
      ),
    );
  }
}
