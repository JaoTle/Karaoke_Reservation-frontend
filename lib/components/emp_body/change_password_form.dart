import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/providers/emp_page_provider.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/account_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ChangePasswordForm extends StatelessWidget {
  bool? _isObsecure;
  var _formKey = GlobalKey<FormState>();
  String? _oldPassword,_cfPassword,_newPassword;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    _isObsecure = context.watch<EmpProvider>().isObsecure;
    return AlertDialog(
      title: Text("Change Password",style: TextStyle(fontFamily: 'MavenPro',color: darkToneColor),textAlign: TextAlign.center,),
      content: Form(
        key: _formKey,
        child: Container(
          height: 170,
          child: Column(
            children: [
              SizedBox(
                width: SizeConfig.screenWidth! * 0.6,
                height: 40,
                child: TextFormField(
                  onSaved: (newValue) => _oldPassword = newValue,
                  decoration: inputDecor("Old Password"),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.6,
                height: 40,
                child: _buildTextField("New Password", context),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.6,
                height: 40,
                child: _buildTextField("Confirm Password", context),
              )
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: secondaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              onPressed: ()async{
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  if(_checkConfirm()){
                    var accout_services = AccountService();
                    var username = Provider.of<UserProvider>(context,listen: false).activeUser.username;
                    String result = await accout_services.changePassword(username, _oldPassword!, _newPassword!);
                    if(result == "Change Password Success"){
                      Navigator.pop(context);
                      Toast.show("Change Password already.",duration: Toast.lengthLong,gravity: Toast.center);
                    }
                    else Toast.show(result,duration: Toast.lengthShort,gravity: Toast.center);
                  }
                  else {
                    Toast.show("Confirm Password not match",duration: Toast.lengthShort,gravity: Toast.center);
                  }
                }
              },
              child: Text("Confirm",
              style: TextStyle(
                fontFamily: 'MavenPro',
                color: secondaryColor),
              )
            ),
            TextButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text("Cancel",
              style: TextStyle(
                fontFamily: 'MavenPro',
                color: secondaryColor),
              )
            )
          ]
    );
  }
  Widget _buildTextField(String label,BuildContext context){
    return TextFormField(
      onSaved: (newValue) {
        if(label == "New Password") _newPassword = newValue;
        else if(label == "Confirm Password") _cfPassword = newValue;
      },
      obscureText: _isObsecure!,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelTextField,
        enabledBorder: inputBorderStyle,
        focusedBorder:inputBorderStyle,
        floatingLabelStyle: inputField,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        suffixIcon: IconButton(
          onPressed: () => context.read<EmpProvider>().setIsObsecure(),
          icon: Icon(
              _isObsecure!
              ?Icons.visibility_rounded
              :Icons.visibility_off_rounded,
              color: lightToneColor,
              size: 30,
            )
      )
      ),
    );
  }
  bool _checkConfirm(){
    if(_newPassword != _cfPassword) return false;
    return true;
  }
}