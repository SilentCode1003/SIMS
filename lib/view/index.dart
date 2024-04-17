import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sims/view/home.dart';
import 'package:sims/view/sales.dart';
import 'package:sims/view/item.dart';
import 'package:sims/view/settings.dart';

class Index extends StatefulWidget {
  const Index({
    Key? key,
  }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  String fullname = '';
  String employeeid = '';
  String image = '';
  bool isLoading = false;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        activeColor: Color.fromRGBO(52, 177, 170, 10),
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Sales();
      case 2:
        return Item();
      case 3:
        return Settings();
      default:
        return Container();
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }
}

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color activeColor;

  const MyBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
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
                        onTap(1);
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
              SizedBox(),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        onTap(2);
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
