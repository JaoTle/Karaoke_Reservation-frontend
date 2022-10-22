import 'package:flutter/material.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/contain_card.dart';
import 'package:karaoke_reservation/components/searchWidget.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/providers/customer_page_provider.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class CustomerBookingBody extends StatefulWidget {
  const CustomerBookingBody({Key? key}) : super(key: key);

  @override
  State<CustomerBookingBody> createState() => _CustomerBookingBodyState();
}

class _CustomerBookingBodyState extends State<CustomerBookingBody> {
  List<BranchModel> branches = [];
  @override
  void initState() {
    getBranches();
    super.initState();
  }

  getBranches()async{
    var branchRoomService = BranchRoomService();
    if(Provider.of<CustomerProvider>(context,listen: false).branches.isEmpty){
      final branchList = await branchRoomService.getBranches('');
      context.read<CustomerProvider>().setBranches(branchList);
    }
  }
  @override
  Widget build(BuildContext context) {
    var query = context.watch<CustomerProvider>().branchTextQuery;
    branches = context.watch<CustomerProvider>().branches;
    return Column(
      children: [
        titleWidget("BOOKING"),
        SizedBox(height: 10),
        SearchWidget(
          text: query, 
          onChanged: searchBranch, 
          hintText: "Branch name", 
          headIcon: Icons.search_rounded
        ),
        SizedBox(height: 10),
        Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child:(branches == []) 
          ? Center(child: CircularProgressIndicator(color: secondaryColor))
          : ListView.builder(
            itemBuilder: (context, index) => _buildBranchCard(branches[index]),
            itemCount: branches.length,
          ),
        ),
      )
      ],
    );
  }

  Widget _buildBranchCard(BranchModel branch){
    return InkWell(
      onTap: (){
        context.read<CustomerProvider>().setSelectedBranch(branch);
        Navigator.pushNamed(context, '/cus_booking');
      },
      child: containCard(
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 10),
          child: Row(
            children: [
              Image.asset('assets/icons/branch.png',width: SizeConfig.screenWidth! * 0.15,),
              SizedBox(width: 20),
              Flexible(
                child: Container(
                  child: Text("${branch.branchName}",style: TextStyle(fontFamily: 'MavenPro',fontSize: 25),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
        0.8
      ),
    );
  }

  searchBranch(String query)async{
    //Call Api get branch
    var branchRoomService = BranchRoomService();
    final branches = await branchRoomService.getBranches(query);
    //set query กับ branches ใน Providers
    
    context.read<CustomerProvider>().setBranchTextQuery(query);
    context.read<CustomerProvider>().setBranches(branches);
  }
}