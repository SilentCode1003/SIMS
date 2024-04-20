import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sims/model/modelinfo.dart';
import 'dart:convert';
import 'package:sims/repository/helper.dart';
import 'package:sims/api/category.dart';
import 'package:sims/api/inventory.dart';

class Item extends StatefulWidget {
  final String branchid;

  const Item({super.key, required this.branchid});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  String categorycode = '';
  String categoryname = '';
  Helper helper = Helper();
  List<CategoryModel> categories = [];
  List<InventoryModel> iteminventory = [];

  @override
  void initState() {
    super.initState();
    _getcategories();
    print(widget.branchid);
    _getinventory();
  }

  Future<void> _getcategories() async {
    final response = await Catergory().categories(categorycode);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      setState(() {
        categories.clear();
        categories.add(CategoryModel(
          "0",
          "All",
          "active",
          "markpogi",
          DateTime.now().toString(),
        ));

        final jsondata = json.encode(response.result);
        for (var branchesinfo in json.decode(jsondata)) {
          CategoryModel categoriesinfos = CategoryModel(
            branchesinfo['categorycode'].toString(),
            branchesinfo['categoryname'],
            branchesinfo['status'],
            branchesinfo['createdby'],
            branchesinfo['createddate'],
          );
          categories.add(categoriesinfos);
        }
      });
    }
  }

  Future<void> _getinventory() async {
    final response = await Inventory().getinventory(widget.branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          InventoryModel items = InventoryModel(
            itemsinfo['id'].toString(),
            itemsinfo['productname'].toString(),
            itemsinfo['branch'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['productimage'].toString(),
          );
          iteminventory.add(items);
        });
      }
    }
  }

  Future<void> _getfilterinventory() async {
    final response =
        await Inventory().filterinventory(widget.branchid, categoryname);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          InventoryModel items = InventoryModel(
            itemsinfo['id'].toString(),
            itemsinfo['productname'].toString(),
            itemsinfo['branch'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['productimage'].toString(),
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
        automaticallyImplyLeading: false,
        title: const Text('Items', style: TextStyle(color: Colors.white)),
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
      body: Stack(
        children: [
          Container(
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10, right: 5, left: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            categoryname = categories[index].categoryname;
                            print(categoryname);
                            print(widget.branchid);
                            setState(() {
                              iteminventory.clear();
                              if (categoryname == 'All') {
                                _getinventory();
                              } else {
                                _getfilterinventory();
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: Color.fromRGBO(52, 177, 170, 10),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            categories[index].categoryname,
                            style: TextStyle(
                              color: Color.fromRGBO(52, 177, 170, 10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.76,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: iteminventory.isEmpty
                      ? Center(
                          child: Text(
                            "No item",
                          ),
                        )
                      : ListView.builder(
                          itemCount: iteminventory.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: Container(
                                height: 90,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        height: 80,
                                        width: 80,
                                        child: Image.memory(
                                          base64Decode(iteminventory[index]
                                              .productimage),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          iteminventory[index].productname,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          iteminventory[index].category,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Quantity: ${iteminventory[index].quantity}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
