import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/services/account_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isObsecure1 = true;
  bool _isObsecure2 = true;
  var _formKey = GlobalKey<FormState>();
  String? name, email, username, password, confirm_password;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextFormField("Name", Icons.badge_outlined),
            SizedBox(height: 30),
            _buildTextFormField("Email", Icons.email_outlined),
            SizedBox(height: 30),
            _buildTextFormField("Username", Icons.person_outline_rounded),
            SizedBox(height: 30),
            _buildTextFormField("Password", Icons.lock_outline_rounded),
            SizedBox(height: 30),
            _buildTextFormField(
                "Confirm password", Icons.check_circle_outline_rounded),
            SizedBox(height: 30),
            SizedBox(
                width: SizeConfig().getScreenWidth() * 0.75,
                height: 50,
                child: normalButton(() async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_checkField()) {
                      var accountService = AccountService();
                      String result = await accountService.signUp(
                          "customer", name!, email!, username!, password!, '');
                      if (result == "Create Account Success")
                        _alertSuccess();
                      else
                        _alertFailed(result);
                    }
                  }
                }, "SIGN UP")),
          ],
        ));
  }

  Widget _buildTextFormField(String label, IconData prefix) {
    return SizedBox(
      width: SizeConfig().getScreenWidth() * 0.75,
      height: 50,
      child: TextFormField(
        onSaved: (newValue) {
          if (label == "Name")
            name = newValue;
          else if (label == "Email")
            email = newValue;
          else if (label == "Username")
            username = newValue;
          else if (label == "Password")
            password = newValue;
          else if (label == "Confirm password") confirm_password = newValue;
        },
        obscureText: (label == "Password" || label == "Confirm password")
            ? (label == "Password") ? _isObsecure1 :_isObsecure2
            : false,
        style: inputField,
        decoration: InputDecoration(
            prefixIcon: Icon(
              prefix,
              color: lightToneColor,
              size: 30,
            ),
            suffixIcon: (label == "Password" || label == "Confirm password")
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if(label == "Password") _isObsecure1 = !_isObsecure1;
                        else _isObsecure2 = !_isObsecure2;
                      });
                    },
                    icon: Icon(
                      (label == "Password") ?
                      _isObsecure1
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded
                      : _isObsecure2
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: lightToneColor,
                      size: 30,
                    ))
                : null,
            labelStyle: labelTextField,
            labelText: label,
            enabledBorder: inputBorderStyle,
            focusedBorder: inputBorderStyle,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: inputField),
      ),
    );
  }

  bool _checkField() {
    if (name!.isEmpty ||
        email!.isEmpty ||
        username!.isEmpty ||
        password!.isEmpty ||
        confirm_password!.isEmpty) {
      _alertInfo();
      return false;
    } else if (password != confirm_password) {
      _alertCheckPassword();
      return false;
    }
    return true;
  }

  void _alertCheckPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password not match", style: titleAlert),
            content: Text(
                "Password and Confirm password not match\nPlease try again.",
                style: detailsAlert),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: btnAlert))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  void _alertInfo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Can not create account", style: titleAlert),
            content: Text("Information not complete,\nEvery field is require.",
                style: detailsAlert),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: btnAlert))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  void _alertSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create Account Success", style: titleAlert),
            content: Text("You have an account.", style: detailsAlert),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/pre-login') ),
                  child: Text("Next", style: btnAlert))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }

  void _alertFailed(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Failed to create account", style: titleAlert),
            content: Text("$msg, Please try again.", style: detailsAlert),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: btnAlert))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
