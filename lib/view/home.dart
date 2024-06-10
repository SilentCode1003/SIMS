import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sims/view/notification.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:sims/view/itembranch.dart';
import 'package:sims/api/home.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedBranch = 'All Branches';
  DateTime _selectedDate = DateTime.now();
  dynamic GrossSales = '';
  dynamic Discounts = '';
  dynamic NetSales = '';
  dynamic Refunds = '';
  dynamic GrossProfit = '';
  String employeeid = '';
  String fullname = '';
  String position = '';
  String usercode = '';
  DateTime year = DateTime.now();
  bool _dataFetched = false;
  Helper helper = Helper();
  List<SalesGraph> salesgraph = [];
  List<EmployeeGraph> employeegraph = [];
  List<TotalItemsModel> totaldailyitems = [];
  List<Topseller> topseller = [];
  List<double> _dataSource = [];

  @override
  void initState() {
    super.initState();
    // _getimage();
    _getUserInfo();
    if (selectedBranch == 'All Branches') {
      _getallweeksales();
      _getalltopseller();
      _getallyeargraphemployee();
    } else {
      setState(() {
        _getbyweeksales();
        _getbytopseller();
        _getbyyeargraphemployee();
      });
    }
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo = await Helper().readJsonToFile('user.json');
    UserModel user = UserModel(
      userinfo['employeeid'].toString(),
      userinfo['fullname'].toString(),
      userinfo['position'].toString(),
      userinfo['contactinfo'].toString(),
      userinfo['datehired'].toString(),
      userinfo['usercode'].toString(),
      userinfo['accesstype'].toString(),
      userinfo['positiontype'].toString(),
      userinfo['status'].toString(),
    );

    setState(() {
      employeeid = user.employeeid;
      fullname = user.fullname;
      position = user.position;
      usercode = user.usercode;
      print('fullname: $fullname');
    });
  }

  Future<void> _getallweeksales() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    final response = await Dashboard().allyearsales(formattedFirstDate);
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
      }
    }
  }

  Future<void> _getbyweeksales() async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedFirstDate = dateFormat.format(year);
    final response =
        await Dashboard().byyearsales(formattedFirstDate, selectedBranch);
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
      }
    }
  }

  Future<void> _getGraphData() async {
    if (selectedBranch == 'All Branches') {
      await _getallyeargraph();
    } else {
      await _getallyeargraph();
    }
  }

  Future<void> _getallyeargraph() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    print('year: $formattedFirstDate');
    final response = await Dashboard().allyeargraph(formattedFirstDate);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        salesgraph = (jsondata as List)
            .map((json) => SalesGraph.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _getbyyeargraph() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    final response =
        await Dashboard().byyeargraph(formattedFirstDate, selectedBranch);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        salesgraph = (jsondata as List)
            .map((json) => SalesGraph.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _getalltopseller() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    final response = await Dashboard().alltopseller(formattedFirstDate);
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
      }
      setState(() {
        _dataSource = dataSource;
      });
    }
  }

  Future<void> _getbytopseller() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    ;
    final response =
        await Dashboard().bytopseller(formattedFirstDate, selectedBranch);
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
      }
      setState(() {
        _dataSource = dataSource;
      });
    }
  }

  Future<void> _getGraphDataEmployee() async {
    if (selectedBranch == 'All Branches') {
      await _getallyeargraphemployee();
    } else {
      await _getbyyeargraphemployee();
    }
  }

  Future<void> _getallyeargraphemployee() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    final response = await Dashboard().alltopemployee(formattedFirstDate);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        employeegraph = (jsondata as List)
            .map((json) => EmployeeGraph.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _getbyyeargraphemployee() async {
    DateFormat dateFormat = DateFormat('yyyy');
    String formattedFirstDate = dateFormat.format(year);
    final response =
        await Dashboard().bytopemployee(formattedFirstDate, selectedBranch);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.decode(json.encode(response.result));
      setState(() {
        employeegraph = (jsondata as List)
            .map((json) => EmployeeGraph.fromJson(json))
            .toList();
      });
    }
  }

  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: const Center(
            child: Text(
              'Are you sure you want to exit?',
              style: TextStyle(fontSize: 15),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            SizedBox(
              width: 120,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              width: 130,
              height: 40,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedFirstDate = DateFormat('yyyy').format(year);
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: 1670,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Color.fromRGBO(52, 177, 170, 10),
                    height: 295,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 65.0),
                      child: Stack(
                        children: [],
                      ),
                    ),
                  )),
              Positioned(
                top: 60,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    'assets/file.png',
                    fit: BoxFit.cover,
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),
              Positioned(
                top: 68,
                left: 90,
                child: Text(
                  "Hey Good Day!",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 87,
                left: 90,
                child: Text(
                  fullname,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 67,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // if (UnreadCount != 0)
                    badges.Badge(
                      badgeContent: const Text(
                        // UnreadCount.toString(),
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      position: badges.BadgePosition.topEnd(
                        top: 0,
                        end: 5,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          size: 25.0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Inbox(
                                usercode: usercode,
                              ),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                  ],
                ),
              ),
              Positioned(
                top: 135,
                right: 0,
                left: 0,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.deepPurple.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.deepPurple,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '₱ ${toCurrencyString(GrossSales.toString())}',
                                  // TotalDaily,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'GROSS SALES',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.repeat,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '₱ ${toCurrencyString(Refunds.toString())}',
                                  // TotalDaily,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'REFUNDS',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.discount,
                                      color: Colors.amber,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '₱ ${toCurrencyString(Discounts.toString())}',
                                  // TotalDaily,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'DISCOUNTS',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
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
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.blueAccent.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.bar_chart,
                                      color: Colors.blueAccent,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '₱ ${toCurrencyString(NetSales.toString())}',
                                  // TotalDaily,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'NET SALES',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.46,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green.withOpacity(0.1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.moving,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '₱ ${toCurrencyString(GrossProfit.toString())}',
                                  // TotalDaily,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                                const Text(
                                  'GROSS PROFIT',
                                  style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 310,
                  left: 10,
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return ItemsBranchSelectionBottomSheet(
                              selectedIndexCallback: (String branch) {
                                setState(() {
                                  selectedBranch = branch;
                                  if (selectedBranch == 'All Branches') {
                                    _getallweeksales();
                                    salesgraph.clear();
                                    _getallyeargraph();
                                    topseller.clear();
                                    _getalltopseller();
                                    employeegraph.clear();
                                    _getallyeargraphemployee();
                                  } else {
                                    setState(() {
                                      _getbyweeksales();
                                      salesgraph.clear();
                                      _getbyyeargraph();
                                      topseller.clear();
                                      _getbytopseller();
                                      employeegraph.clear();
                                      _getbyyeargraphemployee();
                                    });
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.store_outlined,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('$selectedBranch',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      ))),
              Positioned(
                top: 310,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Year"),
                          content: Container(
                            width: 300,
                            height: 300,
                            child: YearPicker(
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime(DateTime.now().year + 100, 1),
                              initialDate: DateTime.now(),
                              selectedDate: _selectedDate,
                              onChanged: (DateTime selectedDate) {
                                setState(() {
                                  year = selectedDate;
                                  if (selectedBranch == 'All Branches') {
                                    _getallweeksales();
                                    salesgraph.clear();
                                    _getallyeargraph();
                                    topseller.clear();
                                    _getalltopseller();
                                    employeegraph.clear();
                                    _getallyeargraphemployee();
                                  } else {
                                    setState(() {
                                      _getbyweeksales();
                                      salesgraph.clear();
                                      _getbyyeargraph();
                                      topseller.clear();
                                      _getbytopseller();
                                      employeegraph.clear();
                                      _getbyyeargraphemployee();
                                    });
                                  }
                                });
                                Navigator.pop(context);
                                print(year);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        DateFormat('yyyy').format(year),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 350,
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 10, bottom: 20, top: 10),
                        child: FutureBuilder<void>(
                          future: !_dataFetched ? _getGraphData() : null,
                          builder: (context, _) {
                            _dataFetched = true;
                            print('SalesGraph datas: $salesgraph');
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
                top: 800,
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                    labelPosition:
                                        ChartDataLabelPosition.inside,
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
                top: 1237,
                left: 10,
                right: 10,
                child: Container(
                  height: 421,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Top Employee',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),
                      employeegraph.isEmpty
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
                                future: !_dataFetched
                                    ? _getGraphDataEmployee()
                                    : null,
                                builder: (context, _) {
                                  _dataFetched = true;
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
                                      ColumnSeries<EmployeeGraph, String>(
                                        color:
                                            Color.fromRGBO(52, 177, 170, 1.0),
                                        dataSource: employeegraph,
                                        xValueMapper:
                                            (EmployeeGraph sales, _) =>
                                                sales.employee,
                                        yValueMapper:
                                            (EmployeeGraph sales, _) =>
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
            ],
          ),
        ),
      )),
    );
  }
}
