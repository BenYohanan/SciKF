import 'package:flutter/material.dart';
import 'package:news_feeds/size_config.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(20)),
            child: Column(
              children: [
                Text(
                  "Welcome back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(30),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Text(
                  "Log in to access your dashboard and manage your projects.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(14),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                LogInForm(formKey: _formKey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signUpScreenRoute);
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}