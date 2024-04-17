import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class Item extends StatefulWidget {
  const Item({super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Items', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
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