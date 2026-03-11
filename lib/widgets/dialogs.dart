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
      backgroundColor: primaryColor,
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
          color: primaryColor,
          fontWeight: FontWeight.w900,
          fontSize: getProportionateScreenWidth(20),
        ),
      ),
    );
  }

}