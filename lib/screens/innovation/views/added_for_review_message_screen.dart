import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/size_config.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';

class AddedForReviewMessageScreen extends StatelessWidget {
  const AddedForReviewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(150)),
                Text(
                  "Successfully!",
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(30),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SvgPicture.asset(
                  "assets/icons/Complete.svg",
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: primaryColor,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "Congratulations! \nYou have successfully submitted you innovation for review.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, mainScreenRoute);
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(16),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
