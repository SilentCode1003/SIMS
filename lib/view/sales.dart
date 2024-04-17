import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sales', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color.fromRGBO(52, 177, 170, 10),
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(right: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                badgeContent: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    size: 25.0,
                  ),
                  onPressed: () {
                  },
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}