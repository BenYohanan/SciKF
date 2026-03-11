import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/widget_helper.dart';

import '../../../../components/custom_bottom_nav_bar.dart';
import '../../../../components/network_image_with_loader.dart';
import '../../../../providers/sci_kf_notifier.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String profileImage = "";
  @override
  void initState() {
    super.initState();

    final user = ref.read(sciKFProvider).user;

    if (user != null) {
      nameController.text = user.fullName ?? "";
      emailController.text = user.email ?? "";
      phoneController.text = user.phoneNumber ?? "";
      profileImage = user.profilePicture ?? "";
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(),
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenHeight(20),
          ),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: getProportionateScreenHeight(70),
                          child: profileImage.isNotEmpty
                              ? NetworkImageWithLoader(
                            profileImage,
                            radius: 150,
                          )
                              : Icon(
                            Icons.person,
                            size: getProportionateScreenHeight(40),
                            color: primaryColor,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: getProportionateScreenWidth(0),
                          child: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: getProportionateScreenHeight(25),
                              backgroundColor: primaryColor,
                              child: SvgPicture.asset(
                                'assets/icons/Edit.svg',
                                height: getProportionateScreenHeight(20),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: getProportionateScreenHeight(10)),

                    Text(
                      emailController.text,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              _buildProfileField(
                icon: 'assets/icons/User.svg',
                label: 'Name',
                controller: nameController,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              _buildProfileField(
                icon: 'assets/icons/Phone.svg',
                label: 'Phone number',
                controller: phoneController,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              WidgetHelper().buildModernButtonWithIcon(
                svgName: "Edit Square.svg",
                text: 'Save Changes',
                color: primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, profileScreenRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String icon,
    required String label,
    required TextEditingController controller
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
      child: TextField(
        cursorColor: primaryColor,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(10)),
            child: SvgPicture.asset(
              icon,
              height: getProportionateScreenHeight(20),
              color: Colors.grey,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: primaryColor,
            fontSize: getProportionateScreenHeight(16),
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenHeight(16),
        ),
        controller: controller,
      ),
    );
  }
}