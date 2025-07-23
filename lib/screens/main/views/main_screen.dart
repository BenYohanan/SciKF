import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../providers/AuthProvider.dart';
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
  bool _isLoading = false;
  var storageService = StorageService();
  var baseHelperService = BaseHelperService();

  Future<void> _refreshMainScreenData({bool forceSync = false}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      baseHelperService.reloadMainScreenData();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
    final outstandingInnovations = authProvider.outstandingInnovations;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: OutstandingCarouselAndCategories(
                  outstandingInnovation: outstandingInnovations,
                  isLoading: _isLoading,
                ),
              ),
              SliverToBoxAdapter(
                child: RecentInnovations(
                  recentInnovation: recentInnovations,
                  isLoading: _isLoading,
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
