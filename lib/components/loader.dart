import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';


class AppLoader {
  static void show(BuildContext context) {
    final rootContext =
        Navigator.of(context, rootNavigator: true).context;

    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: TwistingLoaderWidget(),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class TwistingLoaderWidget extends StatefulWidget {
  const TwistingLoaderWidget({super.key});

  @override
  _TwistingLoaderWidgetState createState() => _TwistingLoaderWidgetState();
}

class _TwistingLoaderWidgetState extends State<TwistingLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.14159,
          child: Container(
            width: getProportionateScreenWidth(50),
            height: getProportionateScreenHeight(50),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: getProportionateScreenWidth(30),
                  height: getProportionateScreenHeight(30),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primaryColor,
                  ),
                  strokeWidth: 4.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
