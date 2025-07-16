import 'package:flutter/material.dart';

import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import 'components/outstanding_carousel_and_categories.dart';
import 'components/recent_innovations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OutstandingCarouselAndCategories()),
            const SliverToBoxAdapter(child: RecentInnovations()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
