import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/route/route_constants.dart';

import '../../../../components/network_image_with_loader.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenHeight(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 28,
                child: NetworkImageWithLoader(
                  'https://i.imgur.com/IXnwbLk.png',
                  radius: 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'SciKF Admin',
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(20),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'admin@scikf.com',
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            _buildProfileItem(
              icon: 'assets/icons/User.svg',
              label: 'Name',
              value: 'Sepide',
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            _buildProfileItem(
              icon: 'assets/icons/Phone.svg',
              label: 'Phone number',
              value: '+1-202-555-0162',
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            _buildProfileItem(
              icon: 'assets/icons/Email.svg',
              label: 'Email',
              value: 'admin@scikf.com',
            ),
            SizedBox(height: getProportionateScreenHeight(50)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, editUserInfoScreenRoute);
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required String icon,
    required String label,
    required String value,
    bool isAction = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: getProportionateScreenHeight(20),
                color: Colors.black,
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: getProportionateScreenHeight(14),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: isAction ? primaryColor : Colors.black,
              fontSize: getProportionateScreenHeight(16),
            ),
          ),
        ],
      ),
    );
  }
}