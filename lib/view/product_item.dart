import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:io';
import '../api/category.dart';
import '../api/product.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:sims/view/itembranch.dart';
import 'package:sims/view/salesbranch.dart';
import 'package:sims/view/product_add.dart';
import 'package:sims/view/inventory_addstocks.dart';
import 'package:sims/view/product_update.dart';
import 'package:sims/view/inventory_search.dart';

class ProductList extends StatefulWidget {
  final String fullname;
  final String employeeid;
  const ProductList(
      {super.key, required this.fullname, required this.employeeid});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isControllerEmpty = true;
  String selectedInterval = 'All';
  String categorycode = '';
  String categoryname = '';
  String selectedBranch = 'all';
  String branchid = '';
  String productid = '';
  Helper helper = Helper();
  TextEditingController reasonController = TextEditingController();
  List<CategoryModel> categories = [];
  List<ProductModel> productlist = [];
  List<ImageModel> images = [];
  Map<String, Image> imageCache = {};

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getcategories();
    _getinventory();
  }

  void updateScreenState(String value) {
    print(value);
    setState(() {
      if (_controller.text.isEmpty) {
        isControllerEmpty = true;
        print('true');
      } else {
        isControllerEmpty = false;
        print('false');
      }
    });
  }

  Future<void> _getcategories() async {
    final response = await Catergory().categories();
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
    final response = await Inventory().getallinventory();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          ProductModel items = ProductModel(
            itemsinfo['productid'].toString(),
            itemsinfo['description'].toString(),
            itemsinfo['price'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['categorycode'].toString(),
            itemsinfo['cost'].toString(),
            itemsinfo['barcode'].toString(),
            itemsinfo['status'].toString(),
          );
          productlist.add(items);
        });
         await _getimage(itemsinfo['productid'].toString());
      }
      printProductIds();
    }
  }

  Future<void> _getimage(String productId) async {
    if (imageCache.containsKey(productId)) {
      return;
    }
    final response = await Inventory().getimage(productId);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var imageinfo in json.decode(jsondata)) {
        setState(() {
          ImageModel image = ImageModel(
            imageinfo['productimage'].toString(),
          );
          images.add(image);
          imageCache[productId] = Image.memory(
            base64Decode(image.productimage),
            fit: BoxFit.cover,
            width: 80.0,
            height: 140.0,
          );
        });
      }
    }
  }

  void printProductIds() {
    for (var item in productlist) {
      productid = item.productid;
      // _getimage();
    }
  }

  Future<void> _getfilterinventory() async {
    final response = await Inventory().filterallinventory(categoryname);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var itemsinfo in json.decode(jsondata)) {
        setState(() {
          ProductModel items = ProductModel(
            itemsinfo['productid'].toString(),
            itemsinfo['description'].toString(),
            itemsinfo['price'].toString(),
            itemsinfo['category'].toString(),
            itemsinfo['categorycode'].toString(),
            itemsinfo['cost'].toString(),
            itemsinfo['barcode'].toString(),
            itemsinfo['status'].toString(),
          );
          productlist.add(items);
        });
      }
    }
  }

  void performSearch(String query) {
    print('Search query: $query');
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:
            const Text('Product List', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                child: Positioned(
                  top: 60,
                  left: 5,
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
                                setState(() {
                                  productlist.clear();
                                  if (selectedBranch == "all") {
                                    if (categoryname == 'All') {
                                      _getinventory();
                                    } else {
                                      _getfilterinventory();
                                    }
                                  } else {
                                    if (categoryname == 'All') {
                                    } else {}
                                  }
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
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
            ],
          ),
          Positioned(
              top: 10,
              left: 10,
              right: 50,
              child: GestureDetector(
                onTap: () {
                  print('search');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromRGBO(52, 177, 170, 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Search Product'), Icon(Icons.search)],
                  ),
                ),
              )),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.extent(
                      maxCrossAxisExtent: 200,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(
                        productlist.length,
                        (index) {
                          return GestureDetector(
                              onTap: () {
                                productid = productlist[index].productid;
                                print(productid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductUpdate(
                                      productid: productid,
                                      employeeid: widget.employeeid,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 0),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                1,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: images.isNotEmpty &&
                                                      images.length > index &&
                                                      images[index]
                                                              .productimage !=
                                                          null
                                                  ? imageCache.containsKey(
                                                          productlist[index]
                                                              .productid)
                                                      ? imageCache[
                                                          productlist[index]
                                                              .productid]
                                                      : Image.memory(
                                                          base64Decode(images[
                                                                  index]
                                                              .productimage),
                                                          fit: BoxFit.cover,
                                                          width: 80.0,
                                                          height: 140.0,
                                                        )
                                                  : Image.asset(
                                                      'assets/paints.png',
                                                      fit: BoxFit.cover,
                                                      width: 80.0,
                                                      height: 140.0,
                                                    ),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        productlist[index].description,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        productlist[index].price,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(52, 177, 170, 10),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                      fullname: widget.fullname,
                      employeeid: widget.employeeid,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
