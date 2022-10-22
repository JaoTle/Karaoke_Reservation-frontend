
import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/user_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/account_services.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class FormAddEmpBody extends StatelessWidget {
  String? name,username,password,branchId;
  bool _isObsecure = true;
  var tools = Tools();
  var initEmp;
  TextEditingController myController = TextEditingController();
  var _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    List<BranchModel> branches = context.watch<CEOProviders>().branches;
    BranchModel selectedbranch = context.watch<CEOProviders>().selectBranch;
    initEmp = context.watch<CEOProviders>().initEmp;
    myController.text = initEmp;
    _isObsecure = context.watch<CEOProviders>().isObsecure;
    return SingleChildScrollView(
      child: Column(
        children: [
          titleWidget("ADD EMPLOYEE"),
          SizedBox(height: 50),
          Form(
            key: _fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Name", Icons.badge_outlined, context),
                SizedBox(height: 30),
                SizedBox(
                  height:50,
                  width: SizeConfig.screenWidth! *0.5,
                  child: DropdownButtonFormField<BranchModel>(
                    onSaved: (newValue) => (newValue != null) ?branchId = newValue.branchId : null,
                    borderRadius: BorderRadius.circular(20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 20),
                      enabledBorder: inputBorderStyle,
                      border: inputBorderStyle,
                      focusedBorder: inputBorderStyle
                    ),
                    hint: Text("สาขา",style: inputThaiField,),
                    items: branches.map<DropdownMenuItem<BranchModel>>((value){
                      return DropdownMenuItem<BranchModel>(
                        value: value,
                        child: Text(value.branchName,style: inputThaiField,),
                      );
                    }).toList(), 
                    onChanged: (value){
                      context.read<CEOProviders>().setSelectedBranch(value!);
                      context.read<CEOProviders>().setInitEmp(tools.generateEmpUser(value.branchId!));
                    }
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField("Username", Icons.person_outline_rounded, context),
                SizedBox(height: 30),
                _buildTextField("Password", Icons.lock_outline_rounded, context)
              ],
            )
          ),
          SizedBox(height: 50,),
          manageButton(()async{
          if(_fromKey.currentState!.validate()){
            _fromKey.currentState!.save();
            if(_checkField()){
              var account_services = AccountService();
              String result = await account_services.signUp("employee", name!, '', username!, password!,branchId!);
              if(result == "Create Account Success") {
                UserModel emp = UserModel(username: username!, password: password!, name: name!, email: null, role: "employee", stationedBranchId: branchId);
                List<UserModel> nowEmp = Provider.of<CEOProviders>(context,listen: false).employees;
                nowEmp.add(emp);
                Provider.of<CEOProviders>(context,listen: false).setEmployees(nowEmp);
                Toast.show(result,duration: Toast.lengthLong,gravity: Toast.center);
                context.read<CEOProviders>().setInitEmp('');
                Navigator.pop(context,'refresh');
              }
              else _alertFailed(result,context);
            }
          }
        }, "เพิ่มพนักงาน", Icons.add)
        ],
      ),
    );
  }

  Widget _buildTextField(String label,IconData prefix,BuildContext context){
    return SizedBox(
            width: SizeConfig.screenWidth! *0.75,
            height: 50,
            child: TextFormField(
              controller: (label == "Password" || label == "Username") ? myController : null,
              onSaved: (newValue){
                if(label == "Name") name = newValue;
                else if(label == "Username") username = newValue;
                else if(label == "Password") password = newValue;
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
                    context.read<CEOProviders>().setObsecure(!_isObsecure);
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
  bool _checkField(){
    if(name!.isEmpty || username!.isEmpty || password!.isEmpty || branchId!.isEmpty) {
      Toast.show("Information not complete.",duration: Toast.lengthLong,gravity: Toast.bottom);
      return false;  
    }
    return true;
  }


  void _alertFailed(String msg,BuildContext context){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Failed to create account",style: titleAlert),
        content: Text("$msg, Please try again.",
        style: detailsAlert),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
            TextButton(onPressed: () => Navigator.pop(context) , 
            child: Text("OK",style: btnAlert)
            )
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    }
    );
  }
}