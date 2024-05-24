import 'package:flutter/material.dart';
import 'package:sims/view/index.dart';
import 'package:sims/view/inventory_item.dart';
import '../api/inventory.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchtState();
}

class _SearchtState extends State<Search> {
  String productname = '';
  bool isControllerEmpty = true;
  TextEditingController _controller = TextEditingController();
  Helper helper = Helper();
  List<InventoryModel> iteminventory = [];
  List<InventoryModel> filteredInventory = [];

  @override
  void initState() {
    super.initState();
    _getinventory();
  }

  Future<void> _getinventory() async {
    final response = await Inventory().getallinventory();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        InventoryModel items = InventoryModel(
          itemsinfo['inventoryid'].toString(),
          itemsinfo['productname'].toString(),
          itemsinfo['branchid'].toString(),
          itemsinfo['quantity'].toString(),
          itemsinfo['category'].toString(),
          itemsinfo['productid'].toString(),
        );
        iteminventory.add(items);
      }
      setState(() {
        filteredInventory = iteminventory;
      });
    }
  }

  void updateScreenState(String value) {
    setState(() {
      if (_controller.text.isEmpty) {
        isControllerEmpty = true;
        filteredInventory = iteminventory;
      } else {
        isControllerEmpty = false;
        filteredInventory = iteminventory
            .where((item) =>
                item.productname.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(71.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 120,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          _controller.clear();
                          Navigator.pop(context);
                          setState(() {
                            isControllerEmpty = true;
                            filteredInventory = iteminventory;
                          });
                        },
                        color: Colors.black,
                        iconSize: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.84,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(52, 177, 170, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              updateScreenState(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search Product',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.clear();
                  isControllerEmpty = true;
                  filteredInventory = iteminventory;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 25, top: 10),
                child: Icon(
                  Icons.clear,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            isControllerEmpty
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  left: 15,
                                  child: Icon(
                                    Icons.access_time,
                                    size: 30.0,
                                    color: Colors.black,
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  left: 60,
                                  child: Text(
                                    'Color',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Transform.rotate(
                                    angle: 4.80,
                                    child: Icon(
                                      Icons.arrow_outward,
                                      size: 30.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ))
                : Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: filteredInventory.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              String productName =
                                  filteredInventory[index].productname;
                              print(productName);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Index(
                                    selectedIndex: 2,
                                    productname: productName,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 5,
                                    left: 15,
                                    child: Icon(
                                      Icons.search,
                                      size: 30.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                      top: 10,
                                      left: 60,
                                      child: Container(
                                        width: 290,
                                        child: Text(
                                          filteredInventory[index].productname,
                                          style: TextStyle(fontSize: 17),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                  Positioned(
                                    top: 5,
                                    right: 15,
                                    child: Transform.rotate(
                                      angle: 4.80,
                                      child: Icon(
                                        Icons.arrow_outward,
                                        size: 30.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
