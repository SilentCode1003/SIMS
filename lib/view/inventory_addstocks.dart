import 'package:flutter/material.dart';
import 'dart:convert';
import '../api/inventory.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../api/branches.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class AddStocks extends StatefulWidget {
  const AddStocks({super.key});

  @override
  State<AddStocks> createState() => _AddStocksState();
}

class _AddStocksState extends State<AddStocks> {
  bool _isChecked = false;
  String items = '';
  String branchid = '';
  String branchids = '';
  String productid = '';
  String? selectedValue;
  TextEditingController _product = TextEditingController();
  TextEditingController _branch = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  Helper helper = Helper();
  List<InventoryModel> iteminventory = [];
  List<InventoryItemModel> itemstock = [];
  List<BranchesModel> branch = [];
  List<String> _productSuggestions = [];
  List<String> _branchSuggestions = [];
  List<int> selectedIndices = [];
  List<Map<String, dynamic>> result = [];

  @override
  void initState() {
    super.initState();
    _getinventory();
    _getbranches();
  }

  Future<void> _addstock() async {
    try {
      String productdata = json.encode(result);
      final response = await Inventory().additemstocks(productdata);
      if (response.status == 200) {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Success",
          ),
        ).then((_) {
          Navigator.of(context).pop();
        });
      } else {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Error",
            text: (response.message),
          ),
        ).then((_) {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print('error $e');
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title: "Error",
          text: "An error occurred",
        ),
      ).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> _getinventory() async {
    final response = await Inventory().getallinventory();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      setState(() {
        iteminventory.clear();
        _productSuggestions.clear();
        for (var itemsinfo in json.decode(jsondata)) {
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
          _productSuggestions.add(itemsinfo['productname'].toString());
        }
      });
    }
  }

  Future<void> _getbranches() async {
    final response = await Branches().branches(branchid);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var branchesinfo in json.decode(jsondata)) {
        setState(() {
          BranchesModel branchesinfos = BranchesModel(
            branchesinfo['branchid'],
            branchesinfo['branchname'],
            branchesinfo['tin'],
            branchesinfo['address'],
            branchesinfo['logo'],
            branchesinfo['status'],
            branchesinfo['createdby'],
            branchesinfo['createddate'],
          );
          branch.add(branchesinfos);
          _branchSuggestions.add(branchesinfo['branchname']);
        });
      }
    }
  }

  Future<void> _getinventoryitem() async {
    final response = await Inventory().getitem(productid, branchids);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      setState(() {
        for (var itemsinfo in json.decode(jsondata)) {
          InventoryItemModel items = InventoryItemModel(
            itemsinfo['inventoryid'].toString(),
            itemsinfo['productname'].toString(),
            itemsinfo['branchid'].toString(),
            itemsinfo['branchname'].toString(),
            itemsinfo['quantity'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['productid'].toString(),
            isChecked: false,
          );
          itemstock.add(items);
        }
      });
    }
  }

  void _handleCheckboxChange(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _incrementQuantity() {
    setState(() {
      int currentQuantity = int.tryParse(_quantity.text) ?? 0;
      _quantity.text = (currentQuantity + 1).toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      int currentQuantity = int.tryParse(_quantity.text) ?? 0;
      if (currentQuantity > 0) {
        _quantity.text = (currentQuantity - 1).toString();
      }
    });
  }

  void deleteSelectedItems() {
    selectedIndices.sort((a, b) => b.compareTo(a));
    for (int index in selectedIndices) {
      itemstock.removeAt(index);
    }
    selectedIndices.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Stocks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: deleteSelectedItems,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 70,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: itemstock.isEmpty
                          ? Center(
                              child: Text(
                                'Select Product',
                              ),
                            )
                          : ListView.builder(
                              itemCount: itemstock.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: Checkbox(
                                                  value: itemstock[index]
                                                      .isChecked,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      itemstock[index]
                                                              .isChecked =
                                                          value ?? false;
                                                      if (value ?? false) {
                                                        // If checkbox is checked, add index to selectedIndices
                                                        selectedIndices
                                                            .add(index);
                                                      } else {
                                                        // If checkbox is unchecked, remove index from selectedIndices
                                                        selectedIndices
                                                            .remove(index);
                                                      }
                                                      print(
                                                          'InventoryID: ${itemstock[index].inventoryid}');
                                                    });
                                                  },
                                                  activeColor: Color.fromRGBO(
                                                      52, 177, 170, 1),
                                                  checkColor: Colors.white,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    color: Colors.white,
                                                    width: 175,
                                                    height: 25,
                                                    child: Text(
                                                      itemstock[index]
                                                          .productname,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    itemstock[index].branchname,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            color: Colors.white,
                                            width: 148,
                                            height: 45,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: _decrementQuantity,
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: TextFormField(
                                                      controller:
                                                          itemstock[index]
                                                              .controller,
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: '0',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[0-9]')),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: _incrementQuantity,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  color: Colors.white,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    height: 300,
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Add Product Quantity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: TypeAheadField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: _product,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                hintText: 'Select Product',
                                                labelStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54),
                                              ),
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return _productSuggestions.where(
                                                (item) => item
                                                    .toLowerCase()
                                                    .contains(
                                                        pattern.toLowerCase()),
                                              );
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              var selectedProduct =
                                                  iteminventory.firstWhere(
                                                      (element) =>
                                                          element.productname ==
                                                          suggestion);
                                              productid =
                                                  selectedProduct.productid;
                                              print(selectedProduct.productid);

                                              _product.text = suggestion;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 20),
                                          child: TypeAheadField(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: _branch,
                                              decoration: InputDecoration(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                hintText: 'Select Branch',
                                                labelStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54),
                                              ),
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return _branchSuggestions.where(
                                                (item) => item
                                                    .toLowerCase()
                                                    .contains(
                                                        pattern.toLowerCase()),
                                              );
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              var selectedBranch =
                                                  branch.firstWhere((element) =>
                                                      element.branchname ==
                                                      suggestion);
                                              branchids =
                                                  selectedBranch.branchid;
                                              print(selectedBranch.branchid);

                                              _branch.text = suggestion;
                                            },
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20, top: 40),
                                            child: Container(
                                              height: 50,
                                              color: Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _product.clear();
                                                      _branch.clear();
                                                      _quantity.clear();
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 113,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      52,
                                                                      177,
                                                                      170,
                                                                      10))),
                                                      child: Center(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      52,
                                                                      177,
                                                                      170,
                                                                      10)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Check if _product and _branch are empty
                                                      if (_product
                                                              .text.isEmpty ||
                                                          _branch
                                                              .text.isEmpty) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title:
                                                                  Text("Error"),
                                                              content: Text(
                                                                  "Please select both product and branch."),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "OK"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        // Proceed with your action
                                                        _getinventoryitem();
                                                        _product.clear();
                                                        _branch.clear();
                                                        _quantity.clear();
                                                        Navigator.pop(context);
                                                        print(productid);
                                                        print(branchids);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      width: 113,
                                                      decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              52, 177, 170, 10),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                        child: Text(
                                                          'Next',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                  color: Color.fromRGBO(52, 177, 170, 10),
                                  width: 1.0),
                            ),
                          ),
                          child: const Text('Add',
                              style: TextStyle(
                                  color: Color.fromRGBO(52, 177, 170, 10))),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 180,
                        child: ElevatedButton(
                          onPressed: itemstock.isEmpty
                              ? null
                              : () {
                                  itemstock.forEach((item) {
                                    Map<String, dynamic> productdata = {
                                      'productid': item.productid,
                                      'quantity': item.controller.text,
                                      'branchid': item.branchid,
                                    };
                                    result.add(productdata);
                                  });
                                  print(result);
                                  _addstock();
                                },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                itemstock.isEmpty
                                    ? Colors.black12
                                    : const Color.fromRGBO(52, 177, 170, 10)),
                          ),
                          child: const Text('Save'),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
