import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import '../../../model/feed_item.dart';
import '../../../size_config.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FeedItem> feedItems = [
      FeedItem(
        title: 'Your innovation request has been approved',
        timeAgo: '2 min ago',
        circleColor: Colors.green[400]!,
        icon: Icons.favorite,
      ),
      FeedItem(
        title: 'Your innovation request has been rejected',
        timeAgo: '6 hours ago',
        circleColor: Colors.red[400]!,
        icon: Icons.store,
      ),
      FeedItem(
        title: 'Your innovation request is still under review',
        timeAgo: '6 hours ago',
        circleColor: Colors.orange[400]!,
        icon: Icons.store,
      ),
    ];
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/DotsV.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          )
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(getProportionateScreenHeight(16.0)),
        itemCount: feedItems.length,
        itemBuilder: (context, index) {
          final item = feedItems[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item.circleColor,
              radius: getProportionateScreenHeight(24),
              child: Icon(item.icon, color: Colors.white, size: getProportionateScreenHeight(20)),
            ),
            title: Text(
              item.title,
              style: TextStyle(fontSize: getProportionateScreenHeight(16), fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              item.timeAgo,
              style: TextStyle(color: Colors.grey[600], fontSize: getProportionateScreenHeight(12)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(8.0)),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
