class BranchesModel {
  final String branchid;
  final String branchname;
  final String tin;
  final String address;
  final String logo;
  final String status;
  final String createdby;
  final String createddate;

  BranchesModel(this.branchid, this.branchname, this.tin, this.address,
      this.logo, this.status, this.createdby, this.createddate);

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    return BranchesModel(
      json['branchid'],
      json['branchname'],
      json['tin'],
      json['address'],
      json['logo'],
      json['status'],
      json['createdby'],
      json['createddate'],
    );
  }
}

class CategoryModel {
  final String categorycode;
  final String categoryname;
  final String status;
  final String createdby;
  final String createddate;

  CategoryModel(this.categorycode, this.categoryname, this.status,
      this.createdby, this.createddate);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      json['categorycode'],
      json['categoryname'],
      json['status'],
      json['createdby'],
      json['createddate'],
    );
  }
}

class InventoryModel {
  final String id;
  final String productname;
  final String branch;
  final String quantity;
  final String category;
  final String productimage;

  InventoryModel(this.id, this.productname, this.branch, this.quantity,
      this.category, this.productimage);

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      json['id'],
      json['productname'],
      json['branch'],
      json['quantity'],
      json['category'],
      json['productimage'],
    );
  }
}

class FilterInventoryModel {
  final String id;
  final String productname;
  final String branch;
  final String quantity;
  final String category;
  final String productimage;

  FilterInventoryModel(this.id, this.productname, this.branch, this.quantity,
      this.category, this.productimage);

  factory FilterInventoryModel.fromJson(Map<String, dynamic> json) {
    return FilterInventoryModel(
      json['id'],
      json['productname'],
      json['branch'],
      json['quantity'],
      json['category'],
      json['productimage'],
    );
  }
}
