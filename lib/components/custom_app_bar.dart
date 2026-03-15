
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../route/route_constants.dart';
import '../size_config.dart';

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.pageHeader,
  });

  final String? pageHeader;

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  final unreadCount = 1;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final notifications = ref.watch(notificationsProvider);
    // final unreadCount = notifications.where((n) => !n.read).length;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor, width: 1.0),
        ),
      ),
      child: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenHeight(16)),
            child: Image.asset(
              logo,
              width: getProportionateScreenWidth(50),
              height: getProportionateScreenHeight(20),
            ),
          ),
        ),
        title: Text(
           'SciDial',
          style: TextStyle(
            fontSize: getProportionateScreenHeight(20),
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: getProportionateScreenHeight(24),
              color: primaryColor,
            ),
          ),
          SizedBox(width: getProportionateScreenHeight(8)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, notificationsScreenRoute);
                },
                icon: unreadCount > 0
                    ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value,
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/icons/Notification.svg",
                    height: getProportionateScreenHeight(24),
                    color: primaryColor,
                  ),
                )
                    : SvgPicture.asset(
                  "assets/icons/Notification.svg",
                  height: getProportionateScreenHeight(24),
                  color: primaryColor,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: getProportionateScreenHeight(8)),
        ],
      ),
    );
  }
}