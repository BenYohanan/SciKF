import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/services/storage_keys.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../providers/SciKFProvider.dart';
import '../../../services/BaseHelperService.dart';
import '../../../services/StorageService.dart';
import 'components/outstanding_carousel_and_categories.dart';
import 'components/recent_innovations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var storageService = StorageService();
  var baseHelperService = BaseHelperService();

  Future<void> _refreshMainScreenData({bool forceSync = false}) async {
    try {
      var userId = await storageService.getFromLocalStorage(loginUserIdKey);
      await baseHelperService.ReloadData(context, userId!);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _refreshData() async {
    await _refreshMainScreenData(forceSync: true);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SciKFProvider>(context);
    final recentInnovations = authProvider.recentInnovations;
    final outstandingInnovations = authProvider.flashInnovations;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _refreshData,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: OutstandingCarouselAndCategories(
                  outstandingInnovation: outstandingInnovations
                ),
              ),
              SliverToBoxAdapter(
                child: RecentInnovations(
                  recentInnovations: recentInnovations
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
