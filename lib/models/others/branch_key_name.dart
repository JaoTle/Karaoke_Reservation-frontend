class BranchKeyName {
  String branchId,branchName;

  BranchKeyName(this.branchId,this.branchName);

  factory BranchKeyName.fromJson(Map<String,dynamic> data){
    return BranchKeyName(data['branchId'], data['branchName']);
  }
  
}