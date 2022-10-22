
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/appBar.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/branch_room_services.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:provider/provider.dart';

class BranchDetailScreen extends StatefulWidget {
  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  PriceDetailsModel? roomS;

  PriceDetailsModel? roomM;

  PriceDetailsModel? roomL;
  CEOProviders? ceoProviders;
  @override
  void didChangeDependencies() {
    ceoProviders = Provider.of<CEOProviders>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var _selectBranch = ModalRoute.of(context)!.settings.arguments as BranchModel;
    getPriceDetail(_selectBranch.branchId!,context);
    roomS = context.watch<CEOProviders>().priceRoomS;
    roomM = context.watch<CEOProviders>().priceRoomM;
    roomL = context.watch<CEOProviders>().priceRoomL;
    return SafeArea(
      child: Scaffold(
        appBar: appBarCustom(true,context),
        body:(roomS == null || roomM == null || roomL == null) 
        ? Center(
          child: CircularProgressIndicator(color: secondaryColor,),
        )
        :SingleChildScrollView(
          child: Column(
            children: [
              centerTitleWidget(_selectBranch.branchName),
              SizedBox(height: SizeConfig.screenHeight! *0.02),
              _buildRoomDetail(_selectBranch.amountRoomS,"s"),
              SizedBox(height: SizeConfig.screenHeight! *0.1),
              _buildRoomDetail(_selectBranch.amountRoomM,"m"),
              SizedBox(height: SizeConfig.screenHeight! *0.1),
              _buildRoomDetail(_selectBranch.amountRoomL,"l")
            ],
          ),
        ),
      )
    );
  }

  Widget _buildRoomDetail(int amountRoom,String size){
    var fo = NumberFormat('###',"en_US");
    var detail;
    String asset = '';
    if(size == 's') {
      asset = "assets/images/room_s.png";
      detail = roomS!;
    }
    else if(size == 'm'){
      asset = "assets/images/room_m.png";
      detail = roomM!;
    }
    else if(size == 'l'){
      asset = "assets/images/room_l.png";
      detail = roomL!; 
      print(roomL!.threeHours);
    } 
    return Padding(
      padding: const EdgeInsets.only(right: 10,left: 10),
      child: Row(
        children: [
          Image.asset(asset,
            height: SizeConfig.screenWidth! * 0.28,
          ),
          SizedBox(width: 10),
          Column(
            children: [
              _buildPriceBox("$amountRoom Rooms"),
              _buildPriceBox("1Hr. : ${fo.format(detail.oneHour)} Baht."),
              _buildPriceBox("2Hrs. : ${fo.format(detail.twoHours)} Baht."),
              _buildPriceBox("3Hrs. : ${fo.format(detail.threeHours)} Baht.")
            ],
          )
        ],
      ),
    );
  }

  void getPriceDetail(String branchId,BuildContext context)async{
    var priceService = BranchRoomService();
    roomS = await priceService.getPrice(branchId, "s");
    roomM = await priceService.getPrice(branchId, "m");
    roomL = await priceService.getPrice(branchId, "l");
    ceoProviders!.setRoomDetails(roomS!, roomM!, roomL!);
  }

  Widget _buildPriceBox(String text){
  return Card(
    color: greyBg,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      padding: EdgeInsets.only(left: 7,right: 7),
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