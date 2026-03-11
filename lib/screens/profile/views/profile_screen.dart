import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/services/StorageService.dart';
import '../../../constants.dart';
import '../../../providers/sci_kf_notifier.dart';
import '../../../route/route_constants.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';
import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(sciKFProvider);
    final user = authState.user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: ListView(
        children: [
          ProfileCard(
            name: user?.fullName ?? "User",
            email: user?.email ?? "",
            imageSrc: user?.profilePicture ?? "",
            press: () {
              Navigator.pushNamed(
                context,
                user == null ? homeScreenRoute : editUserInfoScreenRoute,
              );
            },
          ),
          if (user != null) ...[
            ProfileMenuListTile(
              text: "My Innovations",
              svgSrc: "assets/icons/Innovations.svg",
              press: () {
                Navigator.pushNamed(context, myInnovationScreenRoute);
              },
            ),

            ProfileMenuListTile(
              text: "Post an innovation",
              svgSrc: "assets/icons/Prompt.svg",
              press: () {
                Navigator.pushNamed(context, postAnInnovationScreenRoute);
              },
            ),
          ],
          ProfileMenuListTile(
            text: "My Research",
            svgSrc: "assets/icons/Research.svg",
            press: () {
              Navigator.pushNamed(context, researchScreenRoute);
            },
          ),

          if (user != null && user.isAdmin) ...[
            ProfileMenuListTile(
              text: "Censorship Innovations",
              svgSrc: "assets/icons/Censorship.svg",
              press: () {
                Navigator.pushNamed(context, censorshipInnovationsPageRoute);
              },
            ),
          ],
          ProfileMenuListTile(
            text: "Get Help",
            svgSrc: "assets/icons/Help.svg",
            press: () {},
          ),
          if (user != null) ...[
            ProfileMenuListTile(
              text: "Change Password",
              svgSrc: "assets/icons/Lock.svg",
              press: () {},
            ),
            ProfileMenuListTile(
              text: "Log Out",
              svgSrc: "assets/icons/Logout.svg",
              press: () async {
                await StorageService().clearSecureStorage();
                await StorageService().wipeStorage();

                ref.read(sciKFProvider.notifier).clearState();

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
            ),
          ]else...[
            ProfileMenuListTile(
              text: "Log In",
              svgSrc: "assets/icons/Login.svg",
              press: () async {
                Navigator.pushNamed(context, logInScreenRoute);
              },
            ),
          ],
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
