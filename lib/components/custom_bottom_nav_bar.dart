import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../providers/AuthProvider.dart';
import '../route/route_constants.dart';

class CustomBottomNavBar extends StatefulWidget {
  CustomBottomNavBar({ super.key});
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with RouteAware {
  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
  int _currentIndex = 0;

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pushReplacementNamed(
      context,
      [
        mainScreenRoute,
        homeScreenRoute,
        promptScreenRoute,
        approvedInnovationsScreenRoute,
        profileScreenRoute,
      ][index],
    );
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SciKFProvider>(context);
    final user = authProvider.user;
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
          color ??
              Theme.of(context).iconTheme.color!.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 1,
              ),
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: defaultPadding / 2),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF101015),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.transparent,
        onTap: (index) {
          _navigateToScreen(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Category.svg"),
            activeIcon: svgIcon("assets/icons/Category.svg", color: primaryColor),
            label: "Main",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/home.svg"),
            activeIcon: svgIcon("assets/icons/home.svg", color: primaryColor),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Prompt.svg"),
            activeIcon: svgIcon("assets/icons/Prompt.svg", color: primaryColor),
            label: "Prompt",
          ),
          BottomNavigationBarItem(
            icon: svgIcon("assets/icons/Bookmark.svg"),
            activeIcon: svgIcon("assets/icons/Bookmark.svg", color: primaryColor),
            label: "Innovations",
          ),
        if (user!.id!.isNotEmpty)
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon: svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: "Profile",
            ),
        ],
      ),
    );
  }
}