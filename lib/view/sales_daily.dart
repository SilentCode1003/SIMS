import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'dart:convert';
import '../api/sales_daily.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../api/inventory.dart';

class Daily extends StatefulWidget {
  final String branchid;
  final DateTime date;
  const Daily({super.key, required this.branchid, required this.date});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  String selectedPanel = 'Items';
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String TotalDaily = '';
  String TotalDailyPurchase = '';
  dynamic GrossSales = '';
  dynamic Discounts = '';
  dynamic NetSales = '';
  dynamic Refunds = '';
  dynamic GrossProfit = '';
  Helper helper = Helper();
  DateTime now = DateTime.now();
  DateTime all = DateTime(2024 - 05 - 07);
  bool _dataFetched = false;
  DateTime currentdate = DateTime.now();

  List<TotalDailySalesModel> totaldailysales = [];
  List<DailyTransactionModel> dailytransaction = [];
  List<TotalDailyPurchaseModel> totaldailypurchase = [];
  List<TotalItemsModel> totaldailyitems = [];
  List<StaffModel> totaldailystaff = [];
  List<SalesGraph> salesgraph = [];
  List<Topseller> topseller = [];
  List<double> _dataSource = [];
  List<ImageModel> images = [];
  Map<String, Image> imageCache = {};

  @override
  void initState() {
    super.initState();
    print(widget.date);
    print(widget.branchid);
    if (widget.branchid == 'All Branches') {
      _getalldaysales();
      _getalldaygraph();
      _getalltopseller();
      _getallitems();
      _getallemployee();
    } else {
      setState(() {
        _getbyweeksales();
        _getbydaygraph();
        _getbytopseller();
        _getbyitems();
        _getbyemployee();
      });
    }
  }

  Future<void> _getalldaysales() async {
    print('carlo');
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response = await DailySales().alldailysales(formattedDateRange);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var monthsalesinfo in json.decode(jsondata)) {
        setState(() {
          MonthsalesModel dailysales = MonthsalesModel(
            monthsalesinfo['GrossSales'].toString(),
            monthsalesinfo['Discounts'].toString(),
            monthsalesinfo['NetSales'].toString(),
            monthsalesinfo['Refunds'].toString(),
            monthsalesinfo['GrossProfit'].toString(),
          );
          GrossSales = dailysales.GrossSales;
          Discounts = dailysales.Discounts;
          NetSales = dailysales.NetSales;
          Refunds = dailysales.Refunds;
          GrossProfit = dailysales.GrossProfit;
        });
        print('GrossSales: $GrossSales');
      }
    }
  }

  Future<void> _getbyweeksales() async {
    print('carlo');
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response =
        await DailySales().bydailyssales(formattedDateRange, widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var monthsalesinfo in json.decode(jsondata)) {
        setState(() {
          MonthsalesModel dailysales = MonthsalesModel(
            monthsalesinfo['GrossSales'].toString(),
            monthsalesinfo['Discounts'].toString(),
            monthsalesinfo['NetSales'].toString(),
            monthsalesinfo['Refunds'].toString(),
            monthsalesinfo['GrossProfit'].toString(),
          );
          GrossSales = dailysales.GrossSales;
          Discounts = dailysales.Discounts;
          NetSales = dailysales.NetSales;
          Refunds = dailysales.Refunds;
          GrossProfit = dailysales.GrossProfit;
        });
        print('GrossSales: $GrossSales');
      }
    }
  }

  Future<void> _getalldaygraph() async {
    print('dailygraph');
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('Date Range: $formattedDateRange');
    final response = await DailySales().alldailygraph(formattedDateRange);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        salesgraph = (jsondata as List)
            .map((json) => SalesGraph.fromJson(json))
            .toList();
        salesgraph.forEach((sg) {
          print('Date: ${sg.date}, Total: ${sg.total}');
        });
      });
      print('Data updated.');
    }
  }

  Future<void> _getbydaygraph() async {
    print('dailygraph');
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('Date Range: $formattedDateRange');
    final response =
        await DailySales().bydailygraph(formattedDateRange, widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        salesgraph = (jsondata as List)
            .map((json) => SalesGraph.fromJson(json))
            .toList();
        salesgraph.forEach((sg) {
          print('Date: ${sg.date}, Total: ${sg.total}');
        });
      });
      print('Data updated.');
    }
  }

  Future<void> _getGraphData() async {
    if (widget.branchid == 'All Branches') {
      await _getalldaygraph();
    } else {
      await _getbydaygraph();
    }
  }

  Future<void> _getalltopseller() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response = await DailySales().alltopseller(formattedDateRange);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      List<double> dataSource = [];
      for (var monthsalesinfo in json.decode(jsondata)) {
        setState(() {
          Topseller topsellers = Topseller(
            monthsalesinfo['name'].toString(),
            monthsalesinfo['totalQuantity'].toDouble(),
          );
          topseller.add(topsellers);
          dataSource.add(topsellers.totalQuantity);
        });
        print('GrossSales: $GrossSales');
      }
      setState(() {
        _dataSource = dataSource;
      });
    }
  }

  Future<void> _getbytopseller() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response =
        await DailySales().bytopseller(formattedDateRange, widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      List<double> dataSource = [];
      for (var monthsalesinfo in json.decode(jsondata)) {
        setState(() {
          Topseller topsellers = Topseller(
            monthsalesinfo['name'].toString(),
            monthsalesinfo['totalQuantity'].toDouble(),
          );
          topseller.add(topsellers);
          dataSource.add(topsellers.totalQuantity);
        });
        print('GrossSales: $GrossSales');
      }
      setState(() {
        _dataSource = dataSource;
      });
    }
  }

  Future<void> _getimage(String productId) async {
    if (imageCache.containsKey(productId)) {
      return;
    }
    final response = await Inventory().getimage(productId);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var imageinfo in json.decode(jsondata)) {
        setState(() {
          ImageModel image = ImageModel(
            imageinfo['productimage'].toString(),
          );
          images.add(image);
          imageCache[productId] = Image.memory(
            base64Decode(image.productimage),
            fit: BoxFit.cover,
            width: 50.0,
            height: 50.0,
          );
        });
      }
    }
  }

  Future<void> _getallitems() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response = await DailySales().allitem(formattedDateRange);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          TotalItemsModel dailyitems = TotalItemsModel(
            itemsinfo['productName'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['price'].toString(),
            itemsinfo['productId'].toString(),
            itemsinfo['category'].toString(),
          );
          totaldailyitems.add(dailyitems);
        });
        await _getimage(itemsinfo['productId'].toString());
      }
    }
  }

  Future<void> _getbyitems() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedLastDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate - $formattedLastDate';
    print('date: $formattedDateRange');
    final response =
        await DailySales().byitem(formattedDateRange, widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          TotalItemsModel dailyitems = TotalItemsModel(
            itemsinfo['productName'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['price'].toString(),
            itemsinfo['productId'].toString(),
            itemsinfo['category'].toString(),
          );
          totaldailyitems.add(dailyitems);
        });
        await _getimage(itemsinfo['productId'].toString());
      }
    }
  }

  Future<void> _getallemployee() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate';
    print('date: $formattedDateRange');
    final response = await DailySales().dailyemployee(formattedDateRange);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          StaffModel staffs = StaffModel(
            itemsinfo['cashier'].toString(),
            itemsinfo['totalSales'].toString(),
            itemsinfo['branch'].toString(),
            itemsinfo['soldItems'].toString(),
            itemsinfo['commission'].toString(),
          );
          totaldailystaff.add(staffs);
        });
      }
    }
  }

  Future<void> _getbyemployee() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(now);
    String formattedDateRange = '$formattedFirstDate';
    print('date: $formattedDateRange');
    final response =
        await DailySales().dailybyemployee(formattedDateRange, widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          StaffModel staffs = StaffModel(
            itemsinfo['cashier'].toString(),
            itemsinfo['totalSales'].toString(),
            itemsinfo['branch'].toString(),
            itemsinfo['soldItems'].toString(),
            itemsinfo['commission'].toString(),
          );
          totaldailystaff.add(staffs);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentdate);
    String formattedLastDate = DateFormat('yyyy-MM-dd').format(now);
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned(
                top: 12,
                left: 45,
                right: 45,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    '${DateFormat('MMMM dd, yyyy').format(now)}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            Positioned(
              top: 23,
              left: 28,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    now = now.subtract(Duration(days: 1));
                    print(now);
                    if (widget.branchid == 'All Branches') {
                      _getalldaysales();
                      salesgraph.clear();
                      _getalldaygraph();
                      topseller.clear();
                      _getalltopseller();
                      totaldailyitems.clear();
                      _getallitems();
                      totaldailystaff.clear();
                      _getallemployee();
                    } else {
                      setState(() {
                        _getbyweeksales();
                        salesgraph.clear();
                        _getbydaygraph();
                        topseller.clear();
                        _getbytopseller();
                        totaldailyitems.clear();
                        _getbyitems();
                        totaldailystaff.clear();
                        _getbyemployee();
                      });
                    }
                  });
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 23,
              right: 25,
              child: GestureDetector(
                onTap: () {
                  if (formattedLastDate == formattedCurrentDate) {
                    print('yes');
                    print('firstdate $formattedCurrentDate');
                    print('lastdate $formattedLastDate');
                  } else {
                    print('no');
                    print(formattedLastDate);
                    print(formattedCurrentDate);
                    setState(() {
                      now = now.add(Duration(days: 1));
                      if (widget.branchid == 'All Branches') {
                        _getalldaysales();
                        salesgraph.clear();
                        _getalldaygraph();
                        topseller.clear();
                        _getalltopseller();
                        totaldailyitems.clear();
                        _getallitems();
                        totaldailystaff.clear();
                        _getallemployee();
                      } else {
                        setState(() {
                          _getbyweeksales();
                          salesgraph.clear();
                          _getbydaygraph();
                          topseller.clear();
                          _getbytopseller();
                          totaldailyitems.clear();
                          _getbyitems();
                          totaldailystaff.clear();
                          _getbyemployee();
                        });
                      }
                    });
                  }
                },
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Positioned(
                top: 60,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 177, 170, 10),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₱ ${toCurrencyString(GrossSales.toString())}',
                                                // TotalDaily,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                'Gross Sales',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 177, 170, 10),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₱ ${toCurrencyString(Refunds.toString())}',
                                                // TotalDaily,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                'Refunds',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 177, 170, 10),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₱ ${toCurrencyString(Discounts.toString())}',
                                                // TotalDaily,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                'Discounts',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 177, 170, 10),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₱ ${toCurrencyString(NetSales.toString())}',
                                                // TotalDaily,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                'Net Sales',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(52, 177, 170, 10),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₱ ${toCurrencyString(GrossProfit.toString())}',
                                                // TotalDaily,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              Text(
                                                'Gross Profit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 10,
              right: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 421,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Sales Graph',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    ),
                    salesgraph.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 130),
                            child: Text(
                              'No data found',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 0, right: 10, bottom: 20, top: 10),
                            child: FutureBuilder<void>(
                              future: !_dataFetched ? _getGraphData() : null,
                              builder: (context, _) {
                                _dataFetched = true;
                                print('SalesGraph data: $salesgraph');
                                return SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    majorTickLines: MajorTickLines(size: 0),
                                    labelPlacement: LabelPlacement.onTicks,
                                  ),
                                  primaryYAxis: NumericAxis(
                                    isVisible: true,
                                    numberFormat: NumberFormat.compact(),
                                  ),
                                  series: <CartesianSeries>[
                                    AreaSeries<SalesGraph, String>(
                                      color: Color.fromRGBO(52, 177, 170, 1.0),
                                      dataSource: salesgraph,
                                      xValueMapper: (SalesGraph sales, _) =>
                                          sales.date,
                                      yValueMapper: (SalesGraph sales, _) =>
                                          sales.total,
                                      markerSettings: MarkerSettings(
                                        isVisible: true,
                                      ),
                                      // dataLabelSettings: DataLabelSettings(
                                      //   isVisible: _showDataLabels,
                                      // ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 620,
              left: 10,
              right: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 410,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26, width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Top Sellers',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black26,
                      ),
                    ),
                    topseller.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 130),
                            child: Text(
                              'No data found',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : SfCircularChart(
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                            series: <CircularSeries>[
                              DoughnutSeries<double, String>(
                                dataSource: _dataSource,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true, // Show data labels
                                  labelPosition: ChartDataLabelPosition.inside,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                pointColorMapper: (double value, int index) {
                                  if (index < topseller.length) {
                                    double totalQuantity =
                                        topseller[index].totalQuantity;
                                    if (index >= topseller.length * 0.8) {
                                      return Colors.greenAccent;
                                    } else if (index >=
                                        topseller.length * 0.6) {
                                      return Colors.redAccent;
                                    } else if (index >=
                                        topseller.length * 0.4) {
                                      return Colors.orangeAccent;
                                    } else if (index >=
                                        topseller.length * 0.2) {
                                      return Colors.purpleAccent;
                                    } else {
                                      return Colors.blueAccent;
                                    }
                                  }
                                  return Colors.blueAccent;
                                },
                                xValueMapper: (double value, int index) {
                                  if (index < topseller.length) {
                                    return topseller[index].name;
                                  }
                                  return '';
                                },
                                yValueMapper: (double value, _) => value,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 1057,
              left: 10,
              right: 10,
              child: Container(
                  height: 410,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Items',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                            height: 325,
                            // decoration: BoxDecoration(
                            //     border:
                            //         Border.all(color: Colors.black, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: totaldailyitems.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No data found',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: totaldailyitems.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Items Details"),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Name: ${totaldailyitems[index].productName}"),
                                                        Text(
                                                            "Total Qty: ₱${totaldailyitems[index].quantity}"),
                                                        Text(
                                                            "Total Price: ₱${totaldailyitems[index].price}"),
                                                        // Add more details as needed
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 70,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius:
                                                //     BorderRadius.circular(10),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey
                                                //         .withOpacity(0.5),
                                                //     spreadRadius: 5,
                                                //     blurRadius: 7,
                                                //     offset: const Offset(0, 3),
                                                //   ),
                                                // ],
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: images.isNotEmpty &&
                                                                  images.length >
                                                                      index &&
                                                                  images[index]
                                                                          .productimage !=
                                                                      null
                                                              ? imageCache.containsKey(
                                                                      totaldailyitems[
                                                                              index]
                                                                          .productId)
                                                                  ? imageCache[
                                                                      totaldailyitems[
                                                                              index]
                                                                          .productId]
                                                                  : Image
                                                                      .memory(
                                                                      base64Decode(
                                                                          images[index]
                                                                              .productimage),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          50.0,
                                                                      height:
                                                                          50.0,
                                                                    )
                                                              : Image.asset(
                                                                  'assets/paints.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                ),
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          totaldailyitems[index]
                                                              .productName,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Add ellipsis if text overflows
                                                        ),
                                                        Text(
                                                          'x ${totaldailyitems[index].quantity}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 0.0),
                                                      child: Text(
                                                        '₱ ${toCurrencyString(totaldailyitems[index].price.toString())}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            )),
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: 1495,
              left: 10,
              right: 10,
              child: Container(
                  height: 410,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black26, width: 1)),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Employees',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Container(
                            height: 325,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: totaldailyitems.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No data found',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: totaldailystaff.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Items Details"),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Name: ${totaldailyitems[index].productName}"),
                                                        Text(
                                                            "Total Qty: ₱${totaldailyitems[index].quantity}"),
                                                        Text(
                                                            "Total Price: ₱${totaldailyitems[index].price}"),
                                                        // Add more details as needed
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 70,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.black26,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          totaldailystaff[index]
                                                              .cashier,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          totaldailystaff[index]
                                                              .branch,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 0.0),
                                                      child: Text(
                                                        '₱ ${toCurrencyString(totaldailystaff[index].totalSales.toString())}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            )),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
