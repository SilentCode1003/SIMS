import 'dart:ffi';
import 'package:flutter/material.dart';

class DomainModel {
  final String domain;

  DomainModel(this.domain);

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      json['domain'],
    );
  }
}

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

class PositionModel {
  final String positioncode;
  final String positionname;
  final String status;
  final String createdby;
  final String createddate;

  PositionModel(this.positioncode, this.positionname, this.status,
      this.createdby, this.createddate);

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      json['positioncode'],
      json['positionname'],
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

class NotificationModel {
  final String notificationid;
  final String userid;
  final String branchid;
  final String quantity;
  final String message;
  final String status;
  final String checker;
  final String date;
  final String productname;
  final String branch;

  NotificationModel(
    this.notificationid,
    this.userid,
    this.branchid,
    this.quantity,
    this.message,
    this.status,
    this.checker,
    this.date,
    this.productname,
    this.branch,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      json['notificationid'],
      json['userid'],
      json['branchid'],
      json['quantity'],
      json['message'],
      json['status'],
      json['checker'],
      json['date'],
      json['productname'],
      json['branch'],
    );
  }
}

class PushNotificationModel {
  final String notificationid;
  final String userid;
  final String branchid;
  final String quantity;
  final String message;
  final String status;
  final String checker;
  final String date;
  final String productname;
  final String branch;

  PushNotificationModel(
    this.notificationid,
    this.userid,
    this.branchid,
    this.quantity,
    this.message,
    this.status,
    this.checker,
    this.date,
    this.productname,
    this.branch,
  );

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationModel(
      json['notificationid'],
      json['userid'],
      json['branchid'],
      json['quantity'],
      json['message'],
      json['status'],
      json['checker'],
      json['date'],
      json['productname'],
      json['branch'],
    );
  }
}

class PaymentModel {
  final String paymentid;
  final String paymentname;
  final String status;
  final String createdby;
  final String createddate;

  PaymentModel(this.paymentid, this.paymentname, this.status, this.createdby,
      this.createddate);

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      json['paymentid'],
      json['paymentname'],
      json['status'],
      json['createdby'],
      json['createddate'],
    );
  }
}

class InventoryModel {
  final String inventoryid;
  final String productname;
  final String branchid;
  final String branchname;
  final String quantity;
  final String category;
  final String productid;

  InventoryModel(this.inventoryid, this.productname, this.branchid,
      this.branchname, this.quantity, this.category, this.productid);

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      json['inventoryid'],
      json['productname'],
      json['branchid'],
      json['branchname'],
      json['quantity'],
      json['category'],
      json['productid'],
    );
  }
}

class InventoryItemModel {
  String inventoryid;
  String productname;
  String branchid;
  String branchname;
  String quantity;
  String category;
  String productid;
  bool isChecked;
  late TextEditingController controller; // Declare controller as non-nullable

  InventoryItemModel(
    this.inventoryid,
    this.productname,
    this.branchid,
    this.branchname,
    this.quantity,
    this.category,
    this.productid, {
    this.isChecked = false,
  }) {
    controller =
        TextEditingController(); // Initialize controller in the constructor
  }
}

class ProductModel {
  final String productid;
  final String description;
  final String price;
  final String category;
  final String categorycode;
  final String cost;
  final String barcode;
  final String status;

  ProductModel(this.productid, this.description, this.price, this.category,
      this.categorycode, this.cost, this.barcode, this.status);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json['productid'],
      json['description'],
      json['price'],
      json['category'],
      json['categorycode'],
      json['cost'],
      json['barcode'],
      json['status'],
    );
  }
}

class ImageModel {
  final String productimage;

  ImageModel(this.productimage);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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
      json['inventoryid'],
      json['productname'],
      json['branchid'],
      json['quantity'],
      json['category'],
      json['productid'],
    );
  }
}

class DailyTransactionModel {
  final String detailid;
  final String date;
  final String posid;
  final String shift;
  final String paymenttype;
  final String description;
  final String total;
  final String cashier;
  final String branch;

  DailyTransactionModel(
    this.detailid,
    this.date,
    this.posid,
    this.shift,
    this.paymenttype,
    this.description,
    this.total,
    this.cashier,
    this.branch,
  );

  factory DailyTransactionModel.fromJson(Map<String, dynamic> json) {
    return DailyTransactionModel(
      json['detailid'],
      json['date'],
      json['posid'],
      json['shift'],
      json['paymenttype'],
      json['description'],
      json['total'],
      json['cashier'],
      json['branch'],
    );
  }
}

class TotalDailySalesModel {
  final String totalsales;
  final String totalSold;

  TotalDailySalesModel(this.totalsales, this.totalSold);

  factory TotalDailySalesModel.fromJson(Map<String, dynamic> json) {
    return TotalDailySalesModel(
      json['totalSales'],
      json['totalSold'],
    );
  }
}

class TotalDailyPurchaseModel {
  final String date;
  final String branch;
  final int totalPurchased;

  TotalDailyPurchaseModel(this.date, this.branch, this.totalPurchased);

  factory TotalDailyPurchaseModel.fromJson(Map<String, dynamic> json) {
    return TotalDailyPurchaseModel(
      json['date'],
      json['branch'],
      json['totalPurchased'],
    );
  }
}

class TotalItemsModel {
  final String productName;
  final String quantity;
  final String price;
  final String productId;
  final String category;

  TotalItemsModel(this.productName, this.quantity, this.price, this.productId,
      this.category);

  factory TotalItemsModel.fromJson(Map<String, dynamic> json) {
    return TotalItemsModel(
      json['productName'],
      json['quantity'],
      json['price'],
      json['productId'],
      json['category'],
    );
  }
}

class StaffModel {
  final String cashier;
  final String totalSales;
  final String branch;
  final String soldItems;
  final String commission;

  StaffModel(this.cashier, this.totalSales, this.branch, this.soldItems,
      this.commission);

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      json['cashier'],
      json['totalSales'],
      json['branch'],
      json['soldItems'],
      json['commission'],
    );
  }
}

class MonthsalesModel {
  final String GrossSales;
  final String Discounts;
  final String NetSales;
  final String Refunds;
  final String GrossProfit;

  MonthsalesModel(this.GrossSales, this.Discounts, this.NetSales, this.Refunds,
      this.GrossProfit);

  factory MonthsalesModel.fromJson(Map<String, dynamic> json) {
    return MonthsalesModel(
      json['GrossSales'],
      json['Discounts'],
      json['NetSales'],
      json['Refunds'],
      json['GrossProfit'],
    );
  }
}

class SalesGraph {
  final String date;
  final double total;

  SalesGraph(
    this.date,
    this.total,
  );

  factory SalesGraph.fromJson(Map<String, dynamic> json) {
    return SalesGraph(
      json['date'],
      json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
    );
  }
}

class EmployeeGraph {
  final String date;
  final double total;
  final String employee;

  EmployeeGraph(this.date, this.total, this.employee);

  factory EmployeeGraph.fromJson(Map<String, dynamic> json) {
    return EmployeeGraph(
        json['date'].toString(),
        json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
        json['employee']);
  }
}

class Topseller {
  final String name;
  final double totalQuantity;

  Topseller(
    this.name,
    this.totalQuantity,
  );

  factory Topseller.fromJson(Map<String, dynamic> json) {
    return Topseller(
      json['name'],
      json['totalQuantity'],
    );
  }
}

class EmployeeModel {
  final String employeeid;
  final String fullname;
  final String position;
  final String positionname;
  final String contact;
  final String datehired;
  final String createddate;

  EmployeeModel(this.employeeid, this.fullname, this.position,
      this.positionname, this.contact, this.datehired, this.createddate);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      json['employeeid'],
      json['fullname'],
      json['position'],
      json['positionname'],
      json['contact'],
      json['datehired'],
      json['createddate'],
    );
  }
}

class UserModel {
  final String employeeid;
  final String fullname;
  final String position;
  final String contactinfo;
  final String datehired;
  final String usercode;
  final String accesstype;
  final String positiontype;
  final String status;

  UserModel(
    this.employeeid,
    this.fullname,
    this.position,
    this.contactinfo,
    this.datehired,
    this.usercode,
    this.accesstype,
    this.positiontype,
    this.status,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['employeeid'],
      json['fullname'],
      json['position'],
      json['contactinfo'],
      json['datehired'],
      json['usercode'],
      json['accesstype'],
      json['positiontype'],
      json['status'],
    );
  }
}

// class Category {
//   final String categoryname;
//   final String categorycode;

//   Category(this.categoryname, this.categorycode);
// }
