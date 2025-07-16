import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/route/route_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? drawer;

  const CustomAppBar({super.key, this.drawer});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static Widget get defaultDrawer => Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SciKF',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getProportionateScreenHeight(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildListTile(
          iconPath: 'assets/icons/Prompt.svg',
          title: 'Discover',
          route: promptScreenRoute,
        ),
        _buildListTile(
          iconPath: 'assets/icons/Add.svg',
          title: 'Post an innovation',
          route: postAnInnovationScreenRoute,
        ),
        _buildListTile(
          iconPath: 'assets/icons/Innovations.svg',
          title: 'My Innovations',
          route: "",
        ),
      ],
    ),
  );

  static Widget _buildListTile({
    required String iconPath,
    required String title,
    required String route,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(8),
        vertical: getProportionateScreenHeight(4),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            iconPath,
            height: getProportionateScreenHeight(24),
            color: primaryColor, // SVG icon in primaryColor
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black, // Text in black
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Navigator.pop(navigatorKey.currentContext!); // Close the drawer
            Navigator.pushNamed(navigatorKey.currentContext!, route);
          },
          hoverColor: primaryColor.withOpacity(0.1), // Subtle hover effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        child: Image.asset(
          'assets/img/icon.png',
          width: getProportionateScreenWidth(50),
          height: getProportionateScreenHeight(20),
        ),
      ),
      centerTitle: false,
      title: Row(
        children: [
          Text(
            'SciKF',
            style: TextStyle(
              fontSize: getProportionateScreenHeight(20),
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, searchScreenRoute);
          },
          icon: SvgPicture.asset(
            "assets/icons/Search.svg",
            height: 24,
            color: primaryColor,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, notificationsScreenRoute);
          },
          icon: SvgPicture.asset(
            "assets/icons/Notification.svg",
            height: 24,
            color: primaryColor,
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              "assets/icons/Menu.svg",
              height: 24,
              color: primaryColor,
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenHeight(20)),
      ],
    );
  }
}