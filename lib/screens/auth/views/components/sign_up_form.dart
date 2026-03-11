import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/loader.dart';
import '../../../../constants.dart';
import '../../../../model/auth_models.dart';
import '../../../../route/route_constants.dart';
import '../../../../services/BaseHelperService.dart';
import '../../../../size_config.dart';
import '../../../../widgets/dialogs.dart';
import 'customSuffixIcon.dart';

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
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String _passWordIcon = "assets/icons/View Lock.svg";
  bool _passObscured = true;
  final List<String> _errors = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          _buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          _buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          _buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          GestureDetector(
            onTap: () async {
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
                      "assets/icons/Send.svg",
                      height: getProportionateScreenWidth(18),
                      color: Colors.white,
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text(
                      "Sign Up",
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
        ],
      ),
    );
  }
  Widget _buildEmailFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      controller: _emailController,
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
        labelText: "Email",
        hintText: "Enter your email",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
          color: primaryColor,
        ),
      ),
    );
  }
  Widget _buildPhoneFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _removeError(error: kPhoneNumberNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          _addError(error: kPhoneNumberNullError);
          return kPhoneNumberNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
        ),
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Phone.svg",
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
          child: CustomSuffixIcon(
            svgIcon: _passWordIcon,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
  Widget _buildFullNameFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      controller: _fullNameController,
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _removeError(error: kNameNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          _addError(error: kNameNullError);
          return kNameNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
        ),
        labelText: "Full Name",
        hintText: "Enter your full name",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/User.svg",
          color: primaryColor,
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
