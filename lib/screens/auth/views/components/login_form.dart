import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_feeds/widgets/widget_helper.dart';

import '../../../../components/loader.dart';
import '../../../../constants.dart';
import '../../../../model/auth_models.dart';
import '../../../../route/route_constants.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../services/StorageService.dart';
import '../../../../size_config.dart';
import '../../../../widgets/dialogs.dart';
import 'custom_suffix_icon.dart';

class LogInForm extends ConsumerStatefulWidget {
  const LogInForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  ConsumerState<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends ConsumerState<LogInForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = BaseHelperService();
  final StorageService storageService = StorageService();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String _passWordIcon = "assets/icons/View Lock.svg";
  bool _passObscured = true;
  final List<String> _errors = [];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildUserNameFormField(),
           SizedBox(height: getProportionateScreenHeight(15)),
          _buildPasswordFormField(),
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
          GestureDetector(
            onTap: () async {

              storageService.wipeStorage();
              storageService.clearSecureStorage();

              if (widget.formKey.currentState!.validate()) {

                bool isDialogShown = false;

                if (mounted) {
                  AppLoader.show(context);
                  isDialogShown = true;
                }

                try {

                  final model = LoginModel(
                    userName: _usernameController.text,
                    password: _passwordController.text,
                  );

                  var loginMessage = await _service.login(model, ref);

                  if (loginMessage == "Successfully logged in") {

                    await storageService.saveSecureData(
                        "userEmail", _usernameController.text);

                    await storageService.saveSecureData(
                        "userPassword", _passwordController.text);

                    if (isDialogShown && mounted) {
                      Navigator.pop(context);
                    }

                    if (mounted) {
                      Dialogs.flushBar(
                        context,
                        "Login Successful",
                        "You have successfully logged in.",
                      );

                      Navigator.pushReplacementNamed(
                          context, mainScreenRoute);
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
            child: Container(
              height: getProportionateScreenHeight(50),
              width: screenWidth,
              margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Lock.svg",
                      height: getProportionateScreenWidth(18),
                      color: Colors.white,
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text(
                      "Sign In",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w800,
                        fontSize: getProportionateScreenWidth(17),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(14)),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeScreenRoute,
                        (route) => false,
                  );
                },
                child: Text(
                  "Continue as Guest User",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserNameFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      controller: _usernameController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _removeError(error: kEmailNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          _addError(error: kEmailNullError);
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
        ),
        labelText: "Email or Phone Number",
        hintText: "Enter your email or phone",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: custom_suffix_icon(
          svgIcon: "assets/icons/Mail.svg",
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      obscureText: _passObscured,
      controller: _passwordController,
      focusNode: _passwordFocus,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _removeError(error: kPassNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          _addError(error: kPassNullError);
          return kPassNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
        ),
        labelText: "Password",
        hintText: "Enter your password",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _passObscured = !_passObscured;
              _passWordIcon = _passObscured ? "assets/icons/View Lock.svg" : "assets/icons/View.svg";
            });
          },
          child: custom_suffix_icon(
            svgIcon: _passWordIcon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  void _addError({required String error}) {
    if (!_errors.contains(error)) {
      setState(() => _errors.add(error));
    }
  }

  void _removeError({required String error}) {
    if (_errors.contains(error)) {
      setState(() => _errors.remove(error));
    }
  }
}