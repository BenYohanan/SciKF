import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/providers/sci_kf_notifier.dart';
import 'package:news_feeds/route/route_constants.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(sciKFProvider.notifier).loadUserData();

      final user = ref.read(sciKFProvider).user;

      if (!mounted) {
        return;
      }

      if (user != null) {
        Navigator.pushReplacementNamed(context, mainScreenRoute);
      } else {
        Navigator.pushReplacementNamed(context, logInScreenRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );
  }
}