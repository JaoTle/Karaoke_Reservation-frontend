import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/models/user_model.dart';
import 'package:karaoke_reservation/providers/user_provider.dart';
import 'package:karaoke_reservation/services/account_services.dart';
import 'package:karaoke_reservation/services/booking_service.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class LoginFieldForm extends StatefulWidget {
  LoginFieldForm(this.fromPage);
  String fromPage;
  
  @override
  State<LoginFieldForm> createState() => _LoginFieldFormState();
}

class _LoginFieldFormState extends State<LoginFieldForm> {
  TextEditingController userField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  bool _isObsecure = true;
  var _formKey = GlobalKey<FormState>();
  String? username,password;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField("Username", Icons.person_outline_rounded,userField),
          SizedBox(
            height: 30,
          ),
          _buildTextFormField("Password", Icons.lock_outline_rounded,passwordField),
          SizedBox(height: 50),
          SizedBox(
                width: 200,
                height: 50,
                child: normalButton(
                  ()async{
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      var accountService = AccountService();
                      var user = await accountService.signIn(widget.fromPage, username.toString(), password.toString());
                      if(user != "Failed"){
                        userProvider.setActiveUser(user);
                        if(userProvider.activeUser.role == "Manager"){
                          Navigator.pushNamed(context, '/ceo');
                          userField.text ='';
                          passwordField.text = '';
                        }
                        else if(userProvider.activeUser.role == "Employee"){
                          Navigator.pushNamed(context, '/emp');
                          userField.text ='';
                          passwordField.text = '';
                        }
                        else if(userProvider.activeUser.role == "Customer"){
                          Navigator.pushNamed(context, '/customer');
                          userField.text ='';
                          passwordField.text = '';
                        }
                        var booking_service = BookingService();
                        await booking_service.updateToHistory();
                      } 
                      else{
                        dialogAlert();
                      }
                    }
                  }
                  , "SIGN IN")
              ),
        ],
      )
    );
  }

  void dialogAlert(){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text("Failed to Login",style: titleAlert),
          content: Text("Wrong username or password please try again",
            style: detailsAlert
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context) , 
            child: Text("OK",style: btnAlert)
            )
          ],
        );
      }
    );
  }
  Widget _buildTextFormField(String label,IconData prefix,TextEditingController ctrl){
    return SizedBox(
            width: SizeConfig().getScreenWidth() *0.75,
            height: 50,
            child: TextFormField(
              controller: ctrl,
              onSaved: (newValue){
                if(label =="Password") password = newValue;
                else if(label == "Username") username = newValue;
              },
              obscureText: (label == "Password") ?_isObsecure : false,
              style: inputField,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  prefix,
                  color: lightToneColor,
                  size: 30,
                ),
                suffixIcon: (label == "Password")? IconButton(
                  onPressed: (){
                    setState(() {
                      _isObsecure = !_isObsecure;
                    });
                  }, 
                  icon: Icon(
                    _isObsecure 
                    ?Icons.visibility_rounded
                    :Icons.visibility_off_rounded,
                    color: lightToneColor,
                    size: 30,
                  )
                ):null,
                labelStyle: labelTextField,
                labelText: label,
                enabledBorder: inputBorderStyle,
                focusedBorder:inputBorderStyle,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: inputField
              ),
            ),
          );
  }
}

