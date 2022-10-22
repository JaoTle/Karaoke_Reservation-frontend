
import 'dart:convert';

import 'package:karaoke_reservation/models/branch_model.dart';
import 'package:karaoke_reservation/models/price_details_model.dart';

class AddBranchForm {
  BranchModel branch;
  List<PriceDetailsModel> priceDetailsList;

  AddBranchForm({required this.branch,required this.priceDetailsList});
  
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.branch != null) {
      data['branch'] = this.branch.toJson();
    }
    if (this.priceDetailsList != null) {
      data['priceDetailsList'] =
          this.priceDetailsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
  
