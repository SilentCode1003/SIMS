import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import '../api/category.dart';
import '../api/inventory.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:sims/view/itembranch.dart';
import 'package:sims/view/salesbranch.dart';
import 'package:sims/view/product_add.dart';
import 'package:sims/view/inventory_addstocks.dart';
import 'package:sims/view/product_update.dart';
import 'package:sims/view/inventory_search.dart';

class ItemStocks extends StatefulWidget {
  final String productname;
  final String productid;
  const ItemStocks(
      {super.key, required this.productname, required this.productid});

  @override
  State<ItemStocks> createState() => _ItemStocksState();
}

class _ItemStocksState extends State<ItemStocks> {
  Helper helper = Helper();
  List<ImageModel> images = [];
  List<InventoryModel> iteminventory = [];
  String? base64Image;

  @override
  void initState() {
    super.initState();
    _getimage();
    _getinventory();
  }

  Future<void> _getimage() async {
    final response = await Inventory().getimage(widget.productid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var imageinfo in json.decode(jsondata)) {
        setState(() {
          ImageModel image = ImageModel(
            imageinfo['productimage'].toString(),
          );
          images.add(image);
          base64Image =
              imageinfo['productimage'].toString(); // Store base64 image
        });
      }
    }
  }

  Future<void> _getinventory() async {
    final response = await Inventory().getstocks(widget.productid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          InventoryModel items = InventoryModel(
            itemsinfo['inventoryid'].toString(),
            itemsinfo['productname'].toString(),
            itemsinfo['branchid'].toString(),
            itemsinfo['branchname'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['productid'].toString(),
          );
          iteminventory.add(items);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Stocks',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: base64Image != null
                      ? Image.memory(
                          base64Decode(base64Image!),
                          fit: BoxFit.cover,
                          width: 150.0,
                          height: 150.0,
                        )
                      : Image.asset(
                          'assets/file.png',
                          width: 150.0,
                          height: 150.0,
                        ),
                ),
              ),
            ),
            Positioned.fill(
              top: 166,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.productname,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView.builder(
                itemCount: iteminventory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black26,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Branch: ${iteminventory[index].branchname}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Branch ID: ${iteminventory[index].branchid}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Inventory ID: ${iteminventory[index].inventoryid}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Stock: ${iteminventory[index].quantity}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
