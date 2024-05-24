import 'package:flutter/material.dart';

class AddStocks extends StatefulWidget {
  const AddStocks({super.key});

  @override
  State<AddStocks> createState() => _AddStocksState();
}

class _AddStocksState extends State<AddStocks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Stocks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
      ),
    );
  }
}
