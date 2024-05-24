class Config {
  //static const String apiUrl = "http://192.168.40.101:3050/";
  static const String apiUrl = "http://192.168.40.41:3050/";
  //static const String apiUrl = "https://salesinventory.5lsolutions.com/";

  //Index
  static const String loginAPI = 'login/poslogin'; //
  static const String categoryAPI = 'category/load'; //
  static const String branchesAPI = 'branch/load'; //
  //Dashboard
  static const String yearsales = 'mobile-api/yearlysales'; //
  static const String yeargraph = 'mobile-api//yearly-graph'; //
  static const String yeartopseller = 'mobile-api/year-topseller'; //
  static const String topemployee = 'mobile-api/top-employee';

  //Daily
  static const String alldaysales = 'mobile-api/daily-sales'; //
  static const String dailygraph = 'mobile-api/daily-graph'; //

  //Weekly
  static const String allweeklysales = 'mobile-api/weekly-sales'; //
  static const String weeklygraph = 'mobile-api/weekly-graph'; //
  static const String weeklytopseller = 'mobile-api/weekly-topseller'; //
  static const String item = 'mobile-api/item';

  //Monthly
  static const String allmonthsales = 'mobile-api/monthly-sales'; //
  static const String monthlygraph = 'mobile-api/monthly-graph'; //
  static const String monthlytopseller = 'mobile-api/monthly-topseller'; //
  static const String monthlyitem = 'mobile-api/monthlyitem';

  //Inventory
  static const String allproductAPI = 'mobile-api/inventoryload'; //
  static const String getimageAPI = 'products/image'; //
  static const String allImage = 'mobile-api/allimage'; //
  static const String inventorybranch = 'mobile-api/getinventorybranch';

  //Settings
  static const String saveproduct = 'products/save'; //SAVE PRODUCT

  static const String employee = ''; //EMPLOYEE
  static const String paymentmethod = ''; //PAYMENT
  static const String changepass = ''; //CHANGE PASSWORD

  //Product
  static const String allproductlist = 'mobile-api/loadproduct';
}
