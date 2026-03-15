import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_bottom_nav_bar.dart';
import '../../constants.dart';
import '../../providers/client_provider.dart';
import '../../model/user.dart';
import '../../size_config.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(clientListProvider);

    final filteredClients = users.where((c) {
      final q = _query.toLowerCase();

      final name = (c.fullName ?? '').toLowerCase();
      final phone = c.phoneNumber.toLowerCase();

      return name.contains(q) || phone.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: const CustomAppBar(),
      bottomNavigationBar: CustomBottomNavBar(),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(16)),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(16)),

            Expanded(
              child: filteredClients.isEmpty
                  ? const _EmptyClients()
                  : ListView.builder(
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  return _ClientTile(
                    client: filteredClients[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  final ApplicationUser client;

  const _ClientTile({required this.client});

  @override
  Widget build(BuildContext context) {
    final name = client.fullName ?? '';
    final phone = client.phoneNumber;

    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      padding: EdgeInsets.all(getProportionateScreenHeight(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primaryColor.withOpacity(0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(width: getProportionateScreenHeight(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: getProportionateScreenHeight(13),
                    color: textColor,
                  ),
                ),

                if (phone.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(11),
                        color: Colors.black54,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }
}

class _EmptyClients extends StatelessWidget {
  const _EmptyClients();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.black26,
          ),
          SizedBox(height: 12),
          Text(
            'No users yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your saved users will appear here',
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}