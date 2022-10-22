
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/form/add_branch_form.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:toast/toast.dart';

class AddBranchBody extends StatelessWidget {
  var _fromKey = GlobalKey<FormState>();
  String? branchName;
  int? roomS,roomM,roomL;
  double? oneHour_S,twoHours_S,threeHours_S;
  double? oneHour_M,twoHours_M,threeHours_M;
  double? oneHour_L,twoHours_L,threeHours_L;
  String? result;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SingleChildScrollView(
      child: Form(
        key: _fromKey,
        child: Column(
          children: [
            titleWidget("ADD BRANCH"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/icons/branch.png',
                width: SizeConfig.screenWidth! * 0.2,
              ),
            ),
            SizedBox(height: 20),
            _buildBranchNameField(),
            centerTitleWidget("DETAILS"),
            SizedBox(height: 20),
            containCard(_buildCardForm("S"),0.95),
            containCard(_buildCardForm("M"), 0.95),
            containCard(_buildCardForm("L"), 0.95),
            manageButton((){
              _addBranchForm(context);
            }, "เพิ่มสาขา", Icons.add)
          ],
        ),
      ),
    );
  }

  Widget _buildBranchNameField(){
    return SizedBox(
      width: SizeConfig().getScreenWidth() *0.75,
      height: 50,
      child: TextFormField(
        onSaved: (newValue) => branchName = newValue,
        style: inputField,
        decoration: inputDecor("Branch Name"),
      ),
    );
  }

  Widget _buildCardForm(String size){
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: _buildSizeBox("Size $size"),
          left: 10,
          top: 2,
        ),
        Positioned(
          child: SizedBox(
            width: 80,
            height: 30,
            child: TextFormField(
              onSaved: (newValue) {
                if(newValue != ''){
                  if(size == "S") roomS = int.parse(newValue!);
                  else if(size == "M") roomM = int.parse(newValue!);
                  else if(size == "L") roomL = int.parse(newValue!);
                }
              },
              style: inputField,
              decoration: inputDecor("Rooms"),
            ),
          ),
          left: 10,
          bottom: 10,
        ),
        Positioned(
          child: SizedBox(
            width: 80,
            height: 30,
            child: TextFormField(
              onSaved: (newValue) {
                if(newValue != ''){
                  if(size == "S") oneHour_S = double.parse(newValue!);
                  else if(size == "M") oneHour_M = double.parse(newValue!);
                  else if(size == "L") oneHour_L = double.parse(newValue!);
                }
              },
              style: inputField,
              decoration: inputDecor("฿-1Hr."),
            ),
          ),
          left: 100,
          bottom: 10,
        ),
        Positioned(
          child: SizedBox(
            width: 80,
            height: 30,
            child: TextFormField(
              onSaved: (newValue) {
                if(newValue != ''){
                  if(size == "S") twoHours_S = double.parse(newValue!);
                  else if(size == "M") twoHours_M = double.parse(newValue!);
                  else if(size == "L") twoHours_L = double.parse(newValue!);
                }
              },
              style: inputField,
              decoration: inputDecor("฿-2Hrs."),
            ),
          ),
          right: 100,
          bottom: 10,
        ),
        Positioned(
          child: SizedBox(
            width: 80,
            height: 30,
            child: TextFormField(
              onSaved: (newValue) {
                if(newValue != ''){
                  if(size == "S") threeHours_S = double.parse(newValue!);
                  else if(size == "M") threeHours_M = double.parse(newValue!);
                  else if(size == "L") threeHours_L = double.parse(newValue!);
                }
                
              },
              style: inputField,
              decoration: inputDecor("฿-3Hrs."),
            ),
          ),
          right: 10,
          bottom: 10,
        )
      ],
    );
  }

  Widget _buildSizeBox(String text){
  return Card(
    color: greyBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: 60,
      height: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontFamily: 'MavenPro',fontSize: 16,color: secondaryColor),
        )
      ),
    ),
  );
 }

 void _addBranchForm(BuildContext context)async{
    if(_fromKey.currentState!.validate()){
      _fromKey.currentState!.save();
      if(_checkField(context)){
        List<PriceDetailsModel> priceList = [
          PriceDetailsModel(size: "S", oneHour: oneHour_S!, twoHours: twoHours_S!, threeHours: threeHours_S!),
          PriceDetailsModel(size: "M", oneHour: oneHour_M!, twoHours: twoHours_M!, threeHours: threeHours_M!),
          PriceDetailsModel(size: "L", oneHour: oneHour_L!, twoHours: twoHours_L!, threeHours: threeHours_L!),
        ];
        BranchModel branchModel = BranchModel(branchName: branchName!, amountRoomS: roomS!, amountRoomM: roomM!, amountRoomL: roomL!);
        var addForm = AddBranchForm(branch: branchModel,priceDetailsList: priceList);
        var branchService = BranchRoomService();
        result = await branchService.addBranch(addForm);
        if(result == "Add Branch Success"){
          Toast.show(result!,duration: Toast.lengthLong,gravity: Toast.bottom);
          Navigator.pop(context,'refresh');
        }
        else _alertFailed(result!, context);
      }
    }
 }

void _alertFailed(String msg,BuildContext context){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Failed to add branch",style: titleAlert),
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
   bool _checkField(BuildContext context){
    if(branchName!.isEmpty || roomS == null || roomM == null || roomL == null
    || oneHour_S == null || oneHour_M == null || oneHour_L == null 
    || twoHours_S == null || twoHours_M == null || twoHours_L == null 
    || threeHours_S == null  || threeHours_M == null  || threeHours_L == null 
    ) {
      _alertInfo(context);
      return false;  
    }
    return true;
  }

    void _alertInfo(BuildContext context){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("Can not add branch.",style: titleAlert),
        content: Text("Information not complete,\nEvery field is require.",
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