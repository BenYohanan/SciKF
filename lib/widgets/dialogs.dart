import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class Dialogs {
  static Future flushBar(
      BuildContext context,
      String title,
      String message,
      ) {
    return Flushbar(
      margin: EdgeInsets.all(getProportionateScreenHeight(4)),
      backgroundColor: kPrimaryColor,
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: getProportionateScreenWidth(18),
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 2),
      titleColor: Colors.white,
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize:getProportionateScreenHeight(16),
          color: Colors.white,
        ),
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      maxWidth: 260,
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

  static Widget label(String label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w900,
          fontSize: getProportionateScreenWidth(20),
        ),
      ),
    );
  }

  static void loader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AnimatedContainer(
          curve: Curves.bounceInOut,
          duration: const Duration(seconds: 20),
          child: SizedBox(
            width: getProportionateScreenWidth(25),
            height: getProportionateScreenHeight(25),
            child: Center(
              child: RotatingImage(),
            ),
          ),
        );
      },
    );
  }
}

// Widget for the rotating image
class RotatingImage extends StatefulWidget {
  @override
  _RotatingImageState createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        "assets/img/icon.png",
        width: getProportionateScreenWidth(150),
        height: getProportionateScreenWidth(150),
      ),
    );
  }
}