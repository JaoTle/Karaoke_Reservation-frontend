import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karaoke_reservation/app_screen_size_config.dart';
import 'package:karaoke_reservation/components/title_page.dart';
import 'package:karaoke_reservation/models/coupon_model.dart';
import 'package:karaoke_reservation/providers/ceo_page_provider.dart';
import 'package:karaoke_reservation/services/coupon_service.dart';
import 'package:karaoke_reservation/services/tools/tools.dart';
import 'package:karaoke_reservation/themes/colors.dart';
import 'package:karaoke_reservation/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AddCouponForm extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  var _selectedValue;
  String? couponName,detail,date;
  double? discount;
  int? minHour;
  final ScrollController _firstController = ScrollController();
  TextEditingController? _date;
  TextStyle _styleInfrom = TextStyle(fontFamily: 'K2D',fontSize: 18,color: darkToneColor);
  InputDecoration _styleInput(String text) => InputDecoration(
    labelText: text,
    labelStyle: labelTextField,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: secondaryColor,width: 1.5)) ,
    focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: secondaryColor,width: 1.5)),
    floatingLabelStyle: inputField,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelAlignment: FloatingLabelAlignment.center
  );
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    _selectedValue = context.watch<CEOProviders>().choiceIndex;
    _date = context.watch<CEOProviders>().ctrl;
    return AlertDialog(
      title: titlePage("ADD COUPON"),
      content: Form(
        key: _formKey,
        child: Container(
          height: 300,
          width: SizeConfig.screenWidth! * 0.9,
          child: Scrollbar(
            thickness: 8,
            thumbVisibility: true,
            radius: Radius.circular(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Coupon type : ",style: _styleInfrom),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: ListTile(
                      horizontalTitleGap: 2,
                      leading: Radio(
                        activeColor: darkToneColor,
                        value: 0,
                        groupValue: _selectedValue,
                        onChanged: (value){
                          context.read<CEOProviders>().setChoiceIndex(0);
                        },
                      ),
                      title: Text("ชั่วโมงขั้นต่ำที่ร้อง/1 ครั้ง",style: _styleInfrom,),
                      contentPadding: EdgeInsets.all(1),
                      )
                    ),
                  SizedBox(
                    height: 30,
                    child: ListTile(
                      horizontalTitleGap: 2,
                      leading: Radio(
                        activeColor: darkToneColor,
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (value){
                          context.read<CEOProviders>().setChoiceIndex(1);
                        },
                      ),
                      title: Text("ชั่วโมงสะสมขั่นต่ำ",style: _styleInfrom,),
                      contentPadding: EdgeInsets.all(1),
                    )
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      onSaved: (newValue) => couponName = newValue,
                      style: _styleInfrom,
                      decoration: _styleInput("Coupon Name"),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 80,
                    child: TextFormField(
                      onSaved: (newValue) => detail = newValue,
                      style: _styleInfrom,
                      maxLines: 2,
                      decoration:_styleInput("Detail") ,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => (newValue != '') 
                      ? discount = double.parse(newValue!)
                      : null,
                      style: _styleInfrom,
                      decoration:_styleInput("Discount (Baht.)") ,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => (newValue != '')
                      ?minHour = int.parse(newValue!):null,
                      style: _styleInfrom,
                      decoration:_styleInput("Minimun Hours") ,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      onSaved: (newValue) => date = newValue,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      controller: _date,
                      decoration: InputDecoration(
                        prefixIcon:  Icon(Icons.calendar_month_rounded,color: secondaryColor,),
                        labelText: "Expire Date",
                        labelStyle: labelTextField,
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: secondaryColor,width: 1.5)) ,
                        focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: secondaryColor,width: 1.5)),
                        floatingLabelStyle: inputField,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        floatingLabelAlignment: FloatingLabelAlignment.center
                      ),
                      onTap:()async{
                        DateTime? pick_date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year +1),
                          builder: (context,child) => Theme(
                            data: ThemeData().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: secondaryColor,
                                surface: lightToneColor
                              )
                            ), 
                            child: child!
                          )
                          );
                        if(pick_date != null) {
                          _date!.text = DateFormat("dd-MM-yyyy").format(pick_date);
                          context.read<CEOProviders>().setCtrl(_date!);
                        }
                      } ,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        TextButton(onPressed: () => _toAddCoupon(context), child: Text("Add",style: _styleInfrom)),
        TextButton(onPressed: (){
          _date!.text = '';
          context.read<CEOProviders>().setCtrl(_date!);
          context.read<CEOProviders>().setChoiceIndex(2);
          Navigator.pop(context);
        }, child: Text("Cancel",style: _styleInfrom,))
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
  void _toAddCoupon(BuildContext context)async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      if(_selectedValue == 2) Toast.show("กรุณาเลือกประเภทคูปอง",duration: Toast.lengthLong,gravity: Toast.center);
      else if(couponName == null || detail == null || discount == null || date == null ||minHour == null){
        Toast.show("กรุณากรอกข้อมูลให้ครบถ้วน",duration: Toast.lengthLong,gravity: Toast.center);
      }
      else{
        var isTotalHour;
        if(_selectedValue == 0){
          isTotalHour = false;
        }
        else if(_selectedValue == 1){
          isTotalHour = true;
        }
        CouponModel coupon = CouponModel(
          couponId: "CP-"+GenId().genId(5), 
          couponName: couponName!, 
          details: detail!, 
          hours: minHour! , 
          discount: discount!, 
          isTotalHours: isTotalHour, 
          couponExpire: DateFormat("dd-MM-yyyy").parse(date!));
          var coupon_service = CouponService();
          var response = await coupon_service.addCoupon(coupon);
          context.read<CEOProviders>().addCoupon(coupon);
          Toast.show("$response",duration: Toast.lengthLong,gravity: Toast.center);
          if(response == "Add Coupon Success"){
            _date!.text = '';
            context.read<CEOProviders>().setCtrl(_date!);
            context.read<CEOProviders>().setChoiceIndex(2);
            Navigator.pop(context);
          }
      }
    }
    
  }
}