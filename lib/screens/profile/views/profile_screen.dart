import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/size_config.dart';
import '../../../constants.dart';
import '../../../route/route_constants.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: ListView(
        children: [
          ProfileCard(
            name: "SciKF Admin",
            email: "admin@scikf.com",
            imageSrc: "https://i.imgur.com/IXnwbLk.png",
            press: () {
              Navigator.pushNamed(context, userInfoScreenRoute);
            },
          ),
          SizedBox(height: getProportionateScreenHeight(50)),
          ProfileMenuListTile(
            text: "My Innovations",
            svgSrc: "assets/icons/Innovations.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Post an innovations",
            svgSrc: "assets/icons/Prompt.svg",
            press: () {
              Navigator.pushNamed(context, postAnInnovationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Change Password",
            svgSrc: "assets/icons/Lock.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Settings",
            svgSrc: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Log Out",
            svgSrc: "assets/icons/Logout.svg",
            press: () {
              Navigator.pushNamed(context, logInScreenRoute);
            },
          ),
          ListTile(
            onTap: () {},
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Delete.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
