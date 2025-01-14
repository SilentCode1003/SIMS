import 'package:flutter/material.dart';
import 'dart:convert';

import '../api/branches.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';

class ItemsBranchSelectionBottomSheet extends StatefulWidget {
  final Function(String) selectedIndexCallback;

  const ItemsBranchSelectionBottomSheet(
      {super.key, required this.selectedIndexCallback});

  @override
  _BranchSelectionBottomSheetState createState() =>
      _BranchSelectionBottomSheetState();
}

class _BranchSelectionBottomSheetState
    extends State<ItemsBranchSelectionBottomSheet> {
  String _selectedBranch = '';
  String branchid = '';

  Helper helper = Helper();
  List<BranchesModel> branch = [];

  @override
  void initState() {
    super.initState();
    _getbranches();
  }

  Future<void> _getbranches() async {
    // Add 'All Branches' as the first item
    setState(() {
      branch.add(BranchesModel(
        'All Branches',
        'All Branches',
        '',
        '',
        '',
        '',
        '',
        '',
      ));
    });

    // Fetch branches data
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
        });
      }
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
                    itemCount: branch.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(branch[index].branchname),
                        value: branch[index].branchid,
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
