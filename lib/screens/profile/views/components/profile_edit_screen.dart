import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/route/route_constants.dart';
import 'package:news_feeds/size_config.dart';

import '../../../../components/network_image_with_loader.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String profileImage = 'https://i.imgur.com/IXnwbLk.png';
  String name = 'SciKf Admin';
  String email = 'admin@scikf.com';
  String phone = '+1 202-555-0162';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: getProportionateScreenHeight(70),
                      child: NetworkImageWithLoader(
                        profileImage,
                        radius: getProportionateScreenHeight(150),
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
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              _buildProfileField(
                icon: 'assets/icons/User.svg',
                label: 'Name',
                value: name,
                onChanged: (value) => setState(() => name = value),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              _buildProfileField(
                icon: 'assets/icons/Email.svg',
                label: 'Email',
                value: email,
                onChanged: (value) => setState(() => email = value),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              _buildProfileField(
                icon: 'assets/icons/Phone.svg',
                label: 'Phone number',
                value: phone,
                onChanged: (value) => setState(() => phone = value),
              ),
              SizedBox(height: getProportionateScreenHeight(40)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, mainScreenRoute);
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
    required String value,
    required ValueChanged<String> onChanged,
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
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: getProportionateScreenHeight(16),
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: value),
      ),
    );
  }
}