import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/searchWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/others/branch_key_name.dart';
import 'package:karaoke_reservation/models/user_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/account_services.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddEmpBody extends StatefulWidget {
  const AddEmpBody({Key? key}) : super(key: key);

  @override
  State<AddEmpBody> createState() => _AddEmpBodyState();
}

class _AddEmpBodyState extends State<AddEmpBody> {
  
  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  getEmployees()async{
    var userService = AccountService();
    var branchService = BranchRoomService();
    final empList = await userService.getEmployees('');
    context.read<CEOProviders>().setEmployees(empList);
    final keyBranch = await branchService.getBranchKeyName();
    context.read<CEOProviders>().setBranchKey(keyBranch);
  }
  List<BranchKeyName> branchKeys = [];
  List<UserModel> employees = [];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var query = context.watch<CEOProviders>().employessTextQuery;
    employees = context.watch<CEOProviders>().employees;
    branchKeys = context.watch<CEOProviders>().keyBranch;
    return Column(
      children: [
        titleWidget("EMPLOYEES"),
        SizedBox(height: 20),
        SearchWidget(
          text: query,
          onChanged: searchEmp, 
          hintText: "Emp. Name",
          headIcon: Icons.person_search_rounded,
        ),
        SizedBox(height: 5),
        manageButton(()async{
          await Navigator.pushNamed(context, "/add_emp").then((value){
            if(value =='refresh') getEmployees();
          });
        }, "เพิ่มพนักงาน", Icons.add),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child:(employees == [] || branchKeys ==[]) 
            ? Center(child: CircularProgressIndicator(color: secondaryColor))
            : ListView.builder(
              itemBuilder: (context, index) => _buildCard(employees[index]),
              itemCount: employees.length,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCard(UserModel emp){
    findBranchName(emp.stationedBranchId!);
    DateFormat dateFormat = DateFormat("dd MMM yy, HH.mm");
    return containCard(
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            child: Image.asset("assets/icons/emp.png",
              height: SizeConfig.screenWidth! *0.16 ,
            ),
            left: SizeConfig.screenWidth! *0.02
          ),
          Positioned(
            left: SizeConfig.screenWidth! *0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name,style: infoText),
                Text(findBranchName(emp.stationedBranchId!),style: infoText),
                (emp.recentLogin == null) 
                ? Text("Recent Login : -",style: timeText)
                : Text("Recent Login : ${dateFormat.format(emp.recentLogin!)}",style: timeText)
              ],
            )
          ),
          Positioned(
            child: IconButton(
              icon: Image.asset("assets/icons/recycle-bin.png"),
              onPressed: () => _confirmDelete(emp),
            ),
            right: 10,
            top: 20
          )
        ],
      )
    , 0.85);
  }

  searchEmp(String query)async{
    //Call Api get emp
    var userService = AccountService();
    final emps = await userService.getEmployees(query) ;
    //set query กับ branches ใน Providers
    
    context.read<CEOProviders>().setEmpTextQuery(query);
    context.read<CEOProviders>().setEmployees(emps);
  }

  String findBranchName(String branchId){
    var result = branchKeys.indexWhere((element) => element.branchId == branchId);
    if(result != -1) return branchKeys[result].branchName;
    return "";
  }

  void _confirmDelete(UserModel emp){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text("Confirm Delete?",style: titleAlert),
          content: Text("Do you sure to delete employee \n'${emp.name}'",
            style: detailsAlert
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              onPressed: ()async{
                employees.remove(emp);
                context.read<CEOProviders>().setEmployees(employees);
                var account_services = AccountService();
                String result = await account_services.deleteEmp(emp.username);
                Toast.show(result,duration: Toast.lengthLong,gravity: Toast.center);
                Navigator.pop(context);
              }, 
              child: Text("Yes",style: btnAlert)
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("No",style: btnAlert)
            )
          ],
        );
      }
    );
  }
}