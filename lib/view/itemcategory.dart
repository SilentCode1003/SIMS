import 'package:flutter/material.dart';
import 'dart:convert';

import '../api/category.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';

class ItemsCategorySelectionBottomSheet extends StatefulWidget {
  final Function(String) selectedIndexCallback;

  const ItemsCategorySelectionBottomSheet(
      {super.key, required this.selectedIndexCallback});

  @override
  _BranchSelectionBottomSheetState createState() =>
      _BranchSelectionBottomSheetState();
}

class _BranchSelectionBottomSheetState
    extends State<ItemsCategorySelectionBottomSheet> {
  String _selectedBranch = '';
  String branchid = '';

  Helper helper = Helper();
  List<CategoryModel> category = [];

  @override
  void initState() {
    super.initState();
    _getcategories();
  }

  Future<void> _getcategories() async {
    final response = await Catergory().categories();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      setState(() {
        final jsondata = json.encode(response.result);
        for (var branchesinfo in json.decode(jsondata)) {
          CategoryModel categoriesinfos = CategoryModel(
            branchesinfo['categorycode'].toString(),
            branchesinfo['categoryname'],
            branchesinfo['status'],
            branchesinfo['createdby'],
            branchesinfo['createddate'],
          );
          category.add(categoriesinfos);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Select Branch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(category[index].categoryname),
                        value: category[index].categorycode,
                        groupValue: _selectedBranch,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedBranch = value ?? '';
                            print(_selectedBranch);
                          });
                        },
                        activeColor: const Color.fromRGBO(52, 177, 170, 10),
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                          color: Color.fromRGBO(52, 177, 170, 10), width: 1.0),
                    ),
                  ),
                  child: const Text('Cancel',
                      style:
                          TextStyle(color: Color.fromRGBO(52, 177, 170, 10))),
                ),
              ),
              SizedBox(
                height: 50,
                width: 180,
                child: ElevatedButton(
                  onPressed: _selectedBranch.isEmpty
                      ? null
                      : () {
                          print(_selectedBranch);
                          widget.selectedIndexCallback(_selectedBranch);
                          Navigator.of(context).pop();
                        },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _selectedBranch.isEmpty
                            ? Colors.black12
                            : const Color.fromRGBO(52, 177, 170, 10)),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
