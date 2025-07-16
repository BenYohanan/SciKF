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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(30),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Text(
                  "Log in to access your dashboard and manage your projects.",
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                LogInForm(formKey: _formKey),
                Align(
                  child: TextButton(
                    child: Text(
                      "Forgot password",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        passwordRecoveryScreenRoute,
                      );
                    },
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, mainScreenRoute);
                    }
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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