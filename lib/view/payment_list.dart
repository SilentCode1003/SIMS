import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:
            const Text('Payment Method', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.only(right: 0.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
                badgeContent: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 5),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    size: 25.0,
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
