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
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(clientListProvider.notifier).refreshClients();
    });
  }

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
            SizedBox(height: getProportionateScreenHeight(5)),
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

class _ClientTile extends ConsumerStatefulWidget {
  final ApplicationUser client;

  const _ClientTile({required this.client});

  @override
  ConsumerState<_ClientTile> createState() => _ClientTileState();
}

class _ClientTileState extends ConsumerState<_ClientTile> {
  bool isProcessing = false;

  Future<void> _confirmAction({
    required String title,
    required String message,
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isProcessing = true);

    try {
      final notifier = ref.read(clientListProvider.notifier);

      await action();

      await notifier.refreshClients();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Action failed")),
      );
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.client;
    final name = client.fullName ?? '';
    final phone = client.phoneNumber;
    final email = client.email;

    return Container(
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      padding: EdgeInsets.all(getProportionateScreenHeight(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
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
                    if (email!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          email,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(11),
                            color: Colors.black54,
                          ),
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
            ],
          ),
          if (isProcessing)
            const CircularProgressIndicator()
          else
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: "Make Admin",
                    icon: "assets/icons/Approve.svg",
                    color: Colors.green,
                    onTap: () => _confirmAction(
                      title: "Make Admin",
                      message: "Make this user an admin?",
                      action: () async {
                        await ref
                            .read(clientListProvider.notifier)
                            .makeUserAdmin(client.id!);
                      },
                      successMessage: "User promoted to admin",
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(6)),
                Expanded(
                  child: _actionButton(
                    label: "Delete",
                    icon: "assets/icons/Reject.svg",
                    color: Colors.red,
                    onTap: () => _confirmAction(
                      title: "Delete User",
                      message: "Are you sure you want to delete this user?",
                      action: () async {
                        await ref
                            .read(clientListProvider.notifier)
                            .deleteClient(client.id!);
                      },
                      successMessage: "User promoted to admin",
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget _actionButton({
  required String label,
  required String icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: color.withOpacity(0.1),
      foregroundColor: color,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(color: color),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          height: 14,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    ),
  );
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