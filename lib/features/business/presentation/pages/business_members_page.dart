import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/image_helpers.dart';
import '../providers/business_member_provider.dart';
import 'package:xantina/features/user-auth/domain/entities/app_user.dart';

class BusinessMembersPage extends ConsumerStatefulWidget {
  final String businessId;
  final String businessName;

  const BusinessMembersPage({
    super.key,
    required this.businessId,
    required this.businessName,
  });

  @override
  ConsumerState<BusinessMembersPage> createState() =>
      _BusinessMembersPageState();
}

class _BusinessMembersPageState extends ConsumerState<BusinessMembersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar miembros cuando se inicia la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(businessMemberStateProvider(widget.businessId).notifier)
          .loadMembers(widget.businessId);
    });
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppUser> _getFilteredMembers(List<AppUser> members) {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return members;
    }
    return members.where((member) {
      return member.name.toLowerCase().contains(query) ||
          member.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final memberState = ref.watch(businessMemberStateProvider(widget.businessId));
    final members = memberState.members;
    final isLoading = memberState.isLoading;
    final filteredMembers = _getFilteredMembers(members);

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
          'Miembros del Negocio',
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
          // Lista de miembros
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4A2C1A),
                    ),
                  )
                : filteredMembers.isEmpty
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
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Este negocio no tiene miembros aún'
                                    : 'No se encontraron miembros',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF5A5A5A),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(businessMemberStateProvider(widget.businessId).notifier)
                              .loadMembers(widget.businessId);
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            return _MemberCard(member: member);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final AppUser member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ImageHelpers.buildBase64Image(member.image, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A5F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5A5A5A),
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
