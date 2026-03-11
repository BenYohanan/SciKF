import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/loader.dart';
import '../../../../constants.dart';
import '../../../../model/auth_models.dart';
import '../../../../route/route_constants.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../size_config.dart';
import '../../../../widgets/dialogs.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = BaseHelperService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/User.svg",
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
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _emailController,
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
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: _phoneNumberController,
            cursorColor: primaryColor,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
              prefixIcon: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Phone.svg",
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
          const SizedBox(height: defaultPadding),
          TextFormField(
           controller: _passwordController,
            cursorColor: primaryColor,
            validator: passwordValidator.call,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
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
          const SizedBox(height: defaultPadding * 2),
          ElevatedButton(
            onPressed: () async {
              if (widget.formKey.currentState!.validate()) {
                bool isDialogShown = false;
                if (mounted) {
                  AppLoader.show(context);
                  isDialogShown = true;
                }
                try {
                  final model = RegisterModel(
                    fullName: _fullNameController.text,
                    password: _passwordController.text,
                    phoneNumber: _phoneNumberController.text,
                    email: _emailController.text,
                  );
                  var registerMessage = await _service.register(model);
                  if (registerMessage == "Successfully registered") {
                    if (isDialogShown && mounted) {
                      Navigator.pop(context);
                    }
                    if (mounted) {
                      Dialogs.flushBar(
                        context,
                        "Successful",
                        "You have successfully registered",
                      );
                      Navigator.pushReplacementNamed(context, logInScreenRoute);
                    }
                  } else {
                    if (isDialogShown && mounted) {
                      Navigator.pop(context);
                    }
                    if (mounted) {
                      Dialogs.flushBar(
                        context,
                        "Failed",
                        registerMessage,
                      );
                    }
                  }
                } catch (e) {
                  if (isDialogShown && mounted) {
                    Navigator.pop(context);
                  }
                  if (mounted) {
                    Dialogs.flushBar(
                      context,
                      "Failed",
                      "An error occurred: $e",
                    );
                  }
                }
              }
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                fontSize: getProportionateScreenHeight(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
