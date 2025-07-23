import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/widgets/widget_helper.dart';

import '../../../../constants.dart';
import '../../../../model/auth_models.dart';
import '../../../../route/route_constants.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../services/StorageService.dart';
import '../../../../size_config.dart';
import '../../../../widgets/dialogs.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = BaseHelperService();
  final StorageService storageService = StorageService();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _service.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            cursorColor: primaryColor,
            validator: emaildValidator.call,
            textInputAction: TextInputAction.next,
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
                      BlendMode.srcIn),
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
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
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
            onPressed: () async {
              storageService.wipeStorage();
              storageService.clearSecureStorage();
              if (widget.formKey.currentState!.validate()) {
                bool isDialogShown = false;
                if (mounted) {
                  Dialogs.loader(context);
                  isDialogShown = true;
                }
                try {
                  final model = LoginModel(
                    userName: _usernameController.text,
                    password: _passwordController.text,
                  );
                  var loginMessage = await _service.login(model, context);
                  if (loginMessage == "Successfully logged in") {
                    await storageService.saveSecureData("userEmail", _usernameController.text);
                    await storageService.saveSecureData("userPassword", _passwordController.text);
                    if (isDialogShown && mounted) {
                      Navigator.pop(context);
                    }
                    if (mounted) {
                      Dialogs.flushBar(
                        context,
                        "Login Successful",
                        "You have successfully logged in.",
                      );
                      Navigator.pushReplacementNamed(context, mainScreenRoute);
                    }
                  } else {
                    if (isDialogShown && mounted) {
                      Navigator.pop(context);
                    }
                    if (mounted) {
                      Dialogs.flushBar(
                        context,
                        "Failed",
                        loginMessage,
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
              "Sign in",
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
