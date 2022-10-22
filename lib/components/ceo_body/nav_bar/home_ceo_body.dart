
import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/defualt_button.dart';
import 'package:karaoke_reservation/components/searchWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';

class HomeCEOBody extends StatefulWidget {
  const HomeCEOBody({Key? key}) : super(key: key);

  @override
  State<HomeCEOBody> createState() => _HomeCEOBodyState();
}

class _HomeCEOBodyState extends State<HomeCEOBody> {
  List<BranchModel> branches = [];
  @override
  void initState() {
    getBranches();
    super.initState();
  }

  getBranches()async{
    var branchRoomService = BranchRoomService();
    final branchList = await branchRoomService.getBranches('');
    context.read<CEOProviders>().setBranches(branchList);
  }
  @override
  Widget build(BuildContext context) {
    var query = context.watch<CEOProviders>().branchTextQuery;
    branches = context.watch<CEOProviders>().branches;
    return Column(
      children: [
        titleWidget("BRANCHES"),
        SizedBox(height: 20),
        SearchWidget(
          text: query,
          onChanged: searchBranch, 
          hintText: "Branch Name",
          headIcon: Icons.search,
        ),
        SizedBox(height: 5),
        manageButton(()async{
          await Navigator.pushNamed(context, '/add_branch').then(
            (value){
              if(value == 'refresh') getBranches();
            });
        }, "เพิ่มสาขา", Icons.add),
        SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child:(branches == []) 
            ? Center(child: CircularProgressIndicator(color: secondaryColor))
            : ListView.builder(
              itemBuilder: (context, index) => _buildCard(branches[index]),
              itemCount: branches.length,
            ),
          ),
        )
        //card
      ],
    );
  }

  searchBranch(String query)async{
    //Call Api get branch
    var branchRoomService = BranchRoomService();
    final branches = await branchRoomService.getBranches(query);
    //set query กับ branches ใน Providers
    print(branches.length);
    
    context.read<CEOProviders>().setBranchTextQuery(query);
    context.read<CEOProviders>().setBranches(branches);
  }

 Widget _buildCard(BranchModel branch){
  return InkWell(
    onTap: () => Navigator.pushNamed(context, '/branch_detail',arguments: branch),
    child: containCard(
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            child: Image.asset(
              "assets/icons/branch.png",
              width: SizeConfig.screenWidth! * 0.16,  
            ),
            left: SizeConfig.screenWidth! *0.05,
          ),
          Positioned(
            left: SizeConfig.screenWidth! * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${branch.branchName}",style: labelBranch),
                Row(
                  children: [
                    _buildRoomBox("S : ${branch.amountRoomS}"),
                    _buildRoomBox("M : ${branch.amountRoomM}"),
                    _buildRoomBox("L : ${branch.amountRoomL}"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      0.85
    ),
  );
 }
 Widget _buildRoomBox(String text){
  return Card(
    color: greyBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      width: 70,
      height: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontFamily: 'MavenPro',fontSize: 20,color: secondaryColor),
        )
      ),
    ),
  );
 }
}