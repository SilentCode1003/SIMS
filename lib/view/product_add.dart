import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:sims/view/salesbranch.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:sims/api/inventory.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController Description = TextEditingController();
  TextEditingController Price = TextEditingController();
  TextEditingController Category = TextEditingController();
  TextEditingController Barcode = TextEditingController();
  TextEditingController Cost = TextEditingController();
  String? selectedFile;
  String selectedBranch = '';
  String fullname = 'Joseph Orencio';
  final CurrencyInputFormatter _currencyFormatter = CurrencyInputFormatter();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _save() async {
    String descriptions = Description.text;
    String price = Price.text;
    String category = Category.text;
    String barcode = Barcode.text;
    String cost = Cost.text;

    print(
        'name: $descriptions, price :$price, category: $category, code: $barcode, cost: $cost, fullname: $fullname image: $selectedFile,');

    try {
      final response = await Inventory().save(descriptions, price, category,
          barcode, cost, selectedFile!, fullname);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  child: selectedFile != null && selectedFile!.isNotEmpty
                      ? Image.memory(
                          base64Decode(selectedFile!),
                          width: 180.0,
                          height: 180.0,
                        )
                      : Image.asset(
                          'assets/file.png',
                          width: 180.0,
                          height: 180.0,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Center(
                child: ClipRRect(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                        );
                        if (result != null) {
                          String? filePath = result.files.single.path;
                          if (filePath != null) {
                            List<int> fileBytes =
                                await File(filePath).readAsBytes();
                            setState(() {
                              selectedFile = base64Encode(fileBytes);
                            });
                          } else {
                            print('Failed to read file.');
                          }
                        } else {
                          print('User canceled the picker.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
                      ),
                      child: const Text('Add Image'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 290,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: Color.fromRGBO(52, 177, 170, 10),
                                  height: 100,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.qr_code_2),
                                          onPressed: () {},
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Center(
                                          child: Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Description.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                controller: Description,
                                                maxLines: 20,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter Description here',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 10,
                              left: 35,
                              right: 35,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(52, 177, 170, 10),
                                  ),
                                  child: const Text('Next'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: TextField(
                  controller: Description,
                  enabled: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 360,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          height: 250,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Enter Price',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Center(
                                              child: SizedBox(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: Price,
                                                  maxLines: 1,
                                                  inputFormatters: [
                                                    _currencyFormatter
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: '0.00',
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 40),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(52, 177, 170, 10),
                                  ),
                                  child: const Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: TextField(
                  controller: Price,
                  enabled: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Price',
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 430,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return SalesBranchSelectionBottomSheet(
                        selectedIndexCallback: (String branch) {
                          setState(() {
                            selectedBranch = branch;
                            Category.text = selectedBranch;
                            print('ito na nga $selectedBranch');
                          });
                        },
                      );
                    },
                  );
                },
                child: TextField(
                  controller: Category,
                  enabled: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Category',
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 500,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          height: 250,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Enter Barcode',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Center(
                                              child: SizedBox(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: Barcode,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 35),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(52, 177, 170, 10),
                                  ),
                                  child: const Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: TextField(
                  controller: Barcode,
                  enabled: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Barcode',
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 570,
              left: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          height: 250,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Enter Cost',
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Center(
                                              child: SizedBox(
                                                width: 300,
                                                child: TextFormField(
                                                  controller: Cost,
                                                  maxLines: 1,
                                                  inputFormatters: [
                                                    _currencyFormatter
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: '0.00',
                                                    border:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 40),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(52, 177, 170, 10),
                                  ),
                                  child: const Text('Next'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: TextField(
                  controller: Cost,
                  enabled: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Cost',
                    labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 650,
              left: 30,
              right: 30,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _save();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
