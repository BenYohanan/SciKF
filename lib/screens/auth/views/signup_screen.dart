import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';
import '../../../size_config.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(getProportionateScreenHeight(15)),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Let’s get started!",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(30),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(3)),
                    Text(
                      "Create an account to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    SignUpForm(formKey: _formKey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do you have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, logInScreenRoute);
                          },
                          child: Text(
                            "Sign in",
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
            ],
          ),
        ),
      ),
    );
  }
}
