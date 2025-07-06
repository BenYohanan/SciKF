import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../size_config.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with RouteAware {
  int _selectedIndex = 0;
  bool _isNavigating = false;
  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() => _updateSelectedIndex();
  @override
  void didPopNext() => _updateSelectedIndex();
  @override
  void didPushNext() => _updateSelectedIndex();
  @override
  void didPop() => _updateSelectedIndex();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex();
    });
  }

  void _updateSelectedIndex() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    setState(() {
      switch (currentRoute) {
        case '/':
          _selectedIndex = 0;
          break;
        case '/prompt':
          _selectedIndex = 1;
          break;
        case '/response':
          _selectedIndex = 2;
          break;
        default:
          _selectedIndex = 0;
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index || _isNavigating) return;
    setState(() => _selectedIndex = index);
    _handleNavigation(index);
  }

  Future<void> _handleNavigation(int index) async {
    setState(() => _isNavigating = true);
    try {
      switch (index) {
        case 0:
          if (ModalRoute.of(context)?.settings.name != '/') {
            await Navigator.pushReplacementNamed(context, '/');
          }
          break;
        case 1:
          if (ModalRoute.of(context)?.settings.name != '/prompt') {
            await Navigator.pushReplacementNamed(context, '/prompt');
          }
          break;
        case 2:
          if (ModalRoute.of(context)?.settings.name != '/response') {
            await Navigator.pushReplacementNamed(context, '/response');
          }
          break;
      }
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kTextColor,
      selectedFontSize: getProportionateScreenHeight(12),
      unselectedFontSize: getProportionateScreenHeight(10),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true,
      elevation: 1,
      backgroundColor: Colors.white,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/home.svg",
            height: getProportionateScreenHeight(20),
            color: kTextColor,
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/home.svg",
            height: getProportionateScreenHeight(20),
            color: kPrimaryColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/Prompt.svg",
            height: getProportionateScreenHeight(20),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/Prompt.svg",
            height: getProportionateScreenHeight(20),
            color: kPrimaryColor,
          ),
          label: 'Prompt',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/icons/View.svg",
            height: getProportionateScreenHeight(20),
          ),
          activeIcon: SvgPicture.asset(
            "assets/icons/View.svg",
            height: getProportionateScreenHeight(20),
            color: kPrimaryColor,
          ),
          label: 'Findings',
        ),
      ],
    );
  }
}