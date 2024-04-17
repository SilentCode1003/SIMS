import 'package:flutter/material.dart';
import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getMonthName(int index) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (index >= 0 && index < months.length) {
      return months[index];
    } else {
      return '';
    }
  }

  String getTopSeller(int index) {
    List<String> months = [
      'Brush',
      'Painting',
      'Painting Service',
      '1kg Alrik',
    ];
    if (index >= 0 && index < months.length) {
      return months[index];
    } else {
      return '';
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
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  height: 285,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(52, 177, 170, 10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 65.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 20.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.asset(
                                'assets/file.png',
                                fit: BoxFit.cover,
                                width: 60.0,
                                height: 60.0,
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5.0),
                                Text(
                                  "Hey Good Day!",
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Juan Dela Cruz',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 167.0),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // if (UnreadCount != 0)
                                  badges.Badge(
                                    badgeContent: Text(
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
                                      icon: Icon(
                                        Icons.notifications,
                                        size: 25.0,
                                      ),
                                      onPressed: () {},
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Container 1',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 90.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Container 1',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    top: 300.0,
                    left: 20,
                    right: 20,
                  ),
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 25),
                        child: Text(
                          'Sales Statistic',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            SplineSeries<double, String>(
                              color: const Color.fromRGBO(52, 177, 170, 1.0),
                              dataSource: <double>[
                                1,
                                1,
                                1,
                                5,
                                4,
                              ], // Example data for the spline chart
                              xValueMapper: (double value, _) =>
                                  getMonthName(value.toInt()),
                              yValueMapper: (double value, _) => value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                    top: 700.0,
                    left: 20,
                    right: 20,
                  ),
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 25),
                        child: Text(
                          'Top Seller',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <CartesianSeries>[
                            ColumnSeries<double, String>(
                              color: const Color.fromRGBO(52, 177, 170, 1.0),
                              dataSource: <double>[
                                3,
                                1,
                                2,
                                5,
                              ], // Example data for the column chart
                              xValueMapper: (double value, _) =>
                                  getTopSeller(value.toInt()),
                              yValueMapper: (double value, _) => value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
