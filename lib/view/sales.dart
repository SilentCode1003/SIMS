import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:sims/view/itembranch.dart';
import 'package:sims/view/sales_daily.dart';
import 'package:sims/view/sales_weekly.dart';
import 'package:sims/view/sales_monthly.dart';

class Sales extends StatefulWidget {
  final DateTime date;
  const Sales({super.key, required this.date});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  String selectedPanel = 'daily';
  DateTime Month = DateTime.now();
  dynamic TotalDaily = '';
  dynamic TotalDailyPurchase = '';
  String selectedBranch = 'all';

  Helper helper = Helper();
  List<TotalDailySalesModel> totaldailysales = [];
  List<DailyTransactionModel> dailytransaction = [];
  List<TotalDailyPurchaseModel> totaldailypurchase = [];

  @override
  void initState() {
    super.initState();
    print(DateFormat('yyyy-MM-dd').format(widget.date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Asvesti - $selectedBranch',
            style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.only(right: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.store_outlined,
                  size: 25.0,
                ),
                onPressed: () {
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
                            print('ito na nga $selectedBranch');
                          });
                        },
                      );
                    },
                  );
                },
                color: Colors.white,
              ),
              const SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: 1700,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPanel = 'daily';
                              print('daily');
                            });
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .25,
                            decoration: BoxDecoration(
                              color: selectedPanel == 'daily'
                                  ? Colors.white10
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedPanel == 'daily'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.grey.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Daily',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selectedPanel == 'daily'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPanel = 'weekly';
                              print('weekly');
                            });
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .25,
                            decoration: BoxDecoration(
                              color: selectedPanel == 'weekly'
                                  ? Colors.white10
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedPanel == 'weekly'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.grey.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Weekly',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selectedPanel == 'weekly'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPanel = 'monthly';
                              print('monthly');
                            });
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .25,
                            decoration: BoxDecoration(
                              color: selectedPanel == 'monthly'
                                  ? Colors.white10
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selectedPanel == 'monthly'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.grey.withOpacity(0.1),
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: selectedPanel == 'monthly'
                                    ? const Color.fromRGBO(52, 177, 170, 10)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                child: Stack(
                  children: [
                    //DAILY
                    if (selectedPanel == 'daily')
                      Daily(
                        branchid: selectedBranch,
                        date: widget.date,
                      ),
                    //WEEKLY
                    if (selectedPanel == 'weekly')
                      Weekly(
                        branchid: selectedBranch,
                      ),
                    //MONTHLY
                    if (selectedPanel == 'monthly')
                      Monthly(
                        branchid: selectedBranch,
                        date: Month,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
