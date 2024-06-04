import 'package:flutter/material.dart';

import 'home.dart';
import 'inventory_item.dart';
import 'sales.dart';
import 'settings.dart';
import '../repository/helper.dart';
import '../model/modelinfo.dart';

class Index extends StatefulWidget {
  final int selectedIndex;

  Index({required this.selectedIndex});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  String branch = '';
  String employeeid = '';
  String fullname = '';
  String position = '';
  String usercode = '';

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _getUserInfo();
    print(usercode);
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

      print('usercode: $usercode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_selectedIndex),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarItemTapped,
        activeColor: const Color.fromRGBO(52, 177, 170, 10),
        // onItemsTap: _showBottomModalitems,
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        return Sales(
          date: DateTime.now(),
        );
      case 2:
        return Item(
          usercode: usercode,
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
  final Color activeColor;

  const MyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
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
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Adjusted to space evenly
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
            Column(
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
            // Add more columns here as needed
            Column(
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
                  'Inventory',
                  style: TextStyle(
                    color: currentIndex == 2 ? activeColor : Colors.black,
                  ),
                ),
              ],
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
    );
  }
}
