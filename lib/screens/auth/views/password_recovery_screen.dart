import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';
import '../../../size_config.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    TextFormField(
                      onSaved: (emal) {
                        // Email
                      },
                      validator: emaildValidator.call,
                      textInputAction: TextInputAction.next,
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email address",
                        prefixIcon: Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/Message.svg",
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.3),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Request Reset Link",
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Back to"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, logInScreenRoute);
                          },
                          child: Text(
                            "Sign In",
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
