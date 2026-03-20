import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/route/route_constants.dart';
import '../../constants.dart';
import '../providers/sci_kf_notifier.dart';
import '../size_config.dart';

class CustomBottomNavBar extends ConsumerStatefulWidget {

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  static int _selectedLUTIndex = 0;
  bool _isNavigating = false;
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _newsFeedKey = GlobalKey();
  final GlobalKey _askAIKey = GlobalKey();
  final GlobalKey _innovationKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _selectedLUTIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(sciKFProvider);
    final user = authState.user;

    final items = <BottomNavigationBarItem>[
      if (user != null)
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/Category.svg",
            key: _homeKey,
            color: _selectedLUTIndex == 0 ? primaryColor : Colors.black54,
            height: getProportionateScreenHeight(20),
          ),
          label: 'Home',
        ),

      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Environmental.svg",
          key: _newsFeedKey,
          color: _selectedLUTIndex == (user != null ? 1 : 0)
              ? primaryColor
              : Colors.black54,
          height: getProportionateScreenHeight(20),
        ),
        label: 'News Feed',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Prompt.svg",
          key: _askAIKey,
          color: _selectedLUTIndex == (user != null ? 2 : 1)
              ? primaryColor
              : Colors.black54,
          height: getProportionateScreenHeight(20),
        ),
        label: 'Prompt',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Innovations.svg",
          key: _innovationKey,
          color: _selectedLUTIndex == (user != null ? 3 : 2)
              ? primaryColor
              : Colors.black54,
          height: getProportionateScreenHeight(20),
        ),
        label: 'Innovations',
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Menu.svg",
          key: _menuKey,
          color: _selectedLUTIndex == (user != null ? 4 : 3)
              ? primaryColor
              : Colors.black54,
          height: getProportionateScreenHeight(20),
        ),
        label: 'Menu',
      ),
    ];

    return BottomNavigationBar(
      items: items,
      onTap: (index) async {
        if (_isNavigating) return;
        _onItemTapped(index);
        setState(() {
          _isNavigating = true;
        });
        String? route;
        int actualIndex = user != null ? index : index + 1;
        switch (actualIndex) {
          case 0:
            route = mainScreenRoute;
            break;
          case 1:
            route = researchScreenRoute;
            break;
          case 2:
            route = promptScreenRoute;
            break;
          case 3:
            route = approvedInnovationsScreenRoute;
            break;
          case 4:
            route = profileScreenRoute;
            break;
        }

        if (route != null && ModalRoute.of(context)?.settings.name == route) {
          setState(() {
            _isNavigating = false;
          });
          return;
        }
        final adjustedIndex = user != null ? index : index + 1;
        switch (adjustedIndex) {
          case 0:
            Navigator.pushReplacementNamed(context, mainScreenRoute).then((_) {
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
            break;

          case 1:
            Navigator.pushNamed(context, researchScreenRoute).then((_) {
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
            break;

          case 2:
            Navigator.pushNamed(context, promptScreenRoute).then((_) {
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
            break;

          case 3:
            Navigator.pushNamed(context, approvedInnovationsScreenRoute).then((_) {
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
            break;

          case 4:
            Navigator.pushNamed(context, profileScreenRoute).then((_) {
              if (mounted) {
                setState(() {
                  _isNavigating = false;
                });
              }
            });
            break;
        }
      },
      currentIndex: _selectedLUTIndex,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: getProportionateScreenHeight(12),
      selectedItemColor: primaryColor,
      unselectedItemColor: textColor,
      elevation: 0,
      unselectedFontSize: getProportionateScreenHeight(10),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true,
    );
  }
}