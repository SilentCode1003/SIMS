import 'package:flutter/material.dart';
import 'package:sims/view/home.dart';
import 'package:sims/view/sales.dart';
import 'package:sims/view/item.dart';
import 'package:sims/view/settings.dart';
import 'package:sims/view/salesbranch.dart';
import 'package:sims/view/itembranch.dart';

class Index extends StatefulWidget {
  const Index({
    super.key,
  });

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  String branch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        activeColor: const Color.fromRGBO(52, 177, 170, 10),
        onSalesTap: _showBottomModalsales,
        onItemsTap: _showBottomModalitems,
      ),
    );
  }

  void _showBottomModalsales() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return SalesBranchSelectionBottomSheet(
          selectedIndexCallback: (index, str) {
            setState(() {
              _selectedIndex = index;
              branch = str;
            });
          },
        );
      },
    );
  }

  void _showBottomModalitems() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return ItemsBranchSelectionBottomSheet(
          selectedIndexCallback: (index, str) {
            setState(() {
              _selectedIndex = index;
              branch = str;
            });
          },
        );
      },
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        return Sales(
          branchid: branch,
        );
      case 2:
        return Item(
          branchid: branch,
        );
      case 3:
        return const Settings();
      default:
        return Container();
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onSalesTap;
  final Function() onItemsTap;
  final Color activeColor;

  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onSalesTap,
    required this.onItemsTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomAppBar(
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      onTap(0);
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      color: currentIndex == 0 ? activeColor : Colors.black,
                    ),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: currentIndex == 0 ? activeColor : Colors.black,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // onTap(1);
                        onSalesTap();
                      },
                      icon: Icon(
                        Icons.bar_chart_outlined,
                        color: currentIndex == 1 ? activeColor : Colors.black,
                      ),
                    ),
                    Text(
                      'Sales',
                      style: TextStyle(
                        color: currentIndex == 1 ? activeColor : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        onItemsTap();
                      },
                      icon: Icon(
                        Icons.view_list,
                        color: currentIndex == 2 ? activeColor : Colors.black,
                      ),
                    ),
                    Text(
                      'Items',
                      style: TextStyle(
                        color: currentIndex == 2 ? activeColor : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      onTap(3);
                    },
                    icon: Icon(
                      Icons.settings_rounded,
                      color: currentIndex == 3 ? activeColor : Colors.black,
                    ),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: currentIndex == 3 ? activeColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
