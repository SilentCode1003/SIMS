class Config {
  //static const String apiUrl = "http://192.168.40.101:3050/";
  // static const String apiUrl = "http://192.168.40.48:3050/";
  //static const String apiUrl = "https://salesinventory.5lsolutions.com/";

  //Index
  static const String loginAPI = 'login/poslogin'; //
  static const String changepass = 'mobile-api/changepass'; //
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
  static const String dailyemployeesales = 'mobile-api/employee-sales'; //

  //Weekly
  static const String allweeklysales = 'mobile-api/weekly-sales'; //
  static const String weeklygraph = 'mobile-api/weekly-graph'; //
  static const String weeklytopseller = 'mobile-api/weekly-topseller'; //
  static const String item = 'mobile-api/item'; //
  static const String weeklyemployeesales = 'mobile-api/weekly-employee-sales';

  //Monthly
  static const String allmonthsales = 'mobile-api/monthly-sales'; //
  static const String monthlygraph = 'mobile-api/monthly-graph'; //
  static const String monthlytopseller = 'mobile-api/monthly-topseller'; //
  static const String monthlyitem = 'mobile-api/monthlyitem';
  static const String monthemployeesales = 'mobile-api/month-employee-sales'; //

  //Inventory
  static const String allproductAPI = 'mobile-api/inventoryload'; //
  static const String getimageAPI = 'products/image'; //
  static const String allImage = 'mobile-api/allimage'; //
  static const String inventorybranch = 'mobile-api/getinventorybranch';
  static const String getstocks = 'mobile-api/getinventorybranch';
  static const String inventoryitem = 'mobile-api/getinventoryitem';
  static const String addstocks = 'mobile-api/addstocks';
  static const String ainventoryddstocks = 'mobile-api/addinventory';

  //Settings
  static const String saveproduct = 'mobile-api/addproduct'; //SAVE PRODUCT

  //Product
  static const String allproductlist = 'mobile-api/loadproduct';
  static const String editproduct = 'mobile-api/editproduct';

  //EMPLOYEE
  static const String employeelist = 'mobile-api/employeelist';
  static const String addemployee = 'mobile-api/addemployee';
  static const String editemployee = 'mobile-api/editemployee';
  static const String loadposition = 'mobile-api/loadposition';

  //PAYMENT
  static const String paymentlsit = 'mobile-api/payment';
  static const String addpayment = 'mobile-api/addpayment';
  static const String editpayment = 'mobile-api/editpayment';

  //CATEGORY
  static const String addcategory = 'mobile-api/addcategory';
  static const String editcategory = 'mobile-api/editcategory';

  //BRANCH
  static const String addbranch = 'mobile-api/addbranch';
  static const String editbranch = 'mobile-api/editbranch';

  //NOTIFICATION
  static const String getnotification = 'mobile-api/getnotification';
  static const String readnotification = 'mobile-api/readnotification';
  static const String deletenotification = 'mobile-api/deletenotification';
  static const String recievednotification = 'mobile-api/recievednotification';
}
