import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../api/branches.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class Branch extends StatefulWidget {
  final String fullname;
  final String employeeid;
  const Branch({super.key, required this.fullname, required this.employeeid});

  @override
  State<Branch> createState() => _BranchtState();
}

class _BranchtState extends State<Branch> {
  String branchid = '';
  String? selectedFile;
  String? selectedFileedit;
  Helper helper = Helper();
  List<BranchesModel> branch = [];
  List<BranchesModel> filterbranch = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _image = TextEditingController();
  TextEditingController _addid = TextEditingController();
  TextEditingController _addname = TextEditingController();
  TextEditingController _tin = TextEditingController();
  TextEditingController _addaddress = TextEditingController();
  TextEditingController _editid = TextEditingController();
  TextEditingController _editname = TextEditingController();
  TextEditingController _edittin = TextEditingController();
  TextEditingController _editaddaddress = TextEditingController();
  TextEditingController _editimage = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getbranches();
  }

  Future<void> addbranch() async {
    String branchid = _addid.text;
    String branchname = _addname.text;
    String tin = _tin.text;
    String address = _addaddress.text;
    String createdby = widget.fullname;
    String employeeid = widget.employeeid;

    try {
      final response = await Branches().addbranch(branchid, branchname, tin,
          address, selectedFile!, createdby, employeeid);

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
      print(e);
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

  Future<void> _editbranch() async {
    String branchid = _editid.text;
    String branchname = _editname.text;
    String tin = _edittin.text;
    String address = _editaddaddress.text;
    String employeeid = widget.employeeid;

    try {
      final response = await Branches().editbranch(
          branchid, branchname, tin, address, selectedFileedit!, employeeid);

      print(
          '$branchid, $branchname, $tin, $address, $employeeid, $selectedFileedit');

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
      print(e);
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
          filterbranch = List.from(branch);
        });
      }
    }
  }

  void _filterBranches(String searchText) {
    setState(() {
      filterbranch = branch
          .where((branch) => branch.branchname
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Branches', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.84,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(52, 177, 170, 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 2),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        _filterBranches(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Branch',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              filterbranch = List.from(branch);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filterbranch.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // employeeid = filteredEmployees[index].employeeid;
                      print('save');
                      _editid.text = filterbranch[index].branchid;
                      _editname.text = filterbranch[index].branchname;
                      _edittin.text = filterbranch[index].tin;
                      _editaddaddress.text = filterbranch[index].address;
                      _editimage.text = filterbranch[index].logo;
                      selectedFileedit = filterbranch[index].logo;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Branch Details',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          // Wrap the InkWell with Expanded
                                          child: InkWell(
                                            onTap: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                type: FileType.image,
                                                allowMultiple: false,
                                              );
                                              if (result != null) {
                                                String? filePath =
                                                    result.files.single.path;
                                                if (filePath != null) {
                                                  List<int> fileBytes =
                                                      await File(filePath)
                                                          .readAsBytes();
                                                  setState(() {
                                                    selectedFileedit =
                                                        base64Encode(fileBytes);
                                                    _image.text = result
                                                        .files.single.name;
                                                  });
                                                } else {
                                                  print('Failed to read file.');
                                                }
                                              } else {
                                                print(
                                                    'User canceled the picker.');
                                              }
                                            },
                                            child: IgnorePointer(
                                              child: TextField(
                                                controller: _editimage,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  labelText: 'Branch Logo',
                                                  hintText:
                                                      'Select Branch Logo',
                                                ),
                                                readOnly: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ClipRRect(
                                          child: selectedFileedit != null &&
                                                  selectedFileedit!.isNotEmpty
                                              ? Image.memory(
                                                  base64Decode(
                                                      filterbranch[index].logo),
                                                  width: 80.0,
                                                  height: 80.0,
                                                )
                                              : Image.asset(
                                                  'assets/file.png',
                                                  width: 50.0,
                                                  height: 50.0,
                                                ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: _editid,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Branch ID',
                                        hintText: 'Enter Branch ID',
                                      ),
                                      readOnly: true,
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      controller: _editname,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Branch Name',
                                        hintText: 'Enter Branch Name',
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      controller: _edittin,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'TIN',
                                        hintText: 'Enter TIN',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextField(
                                      controller: _editaddaddress,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Address',
                                        hintText: 'Enter Address',
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    GestureDetector(
                                      onTap: () {
                                        _editbranch();
                                        print('update');
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(52, 177, 170, 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(52, 177, 170, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 17, left: 75),
                            child: Text(
                              filterbranch[index].branchname,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 37, left: 75),
                            child: Text(
                              filterbranch[index].branchid,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          ),
                          Positioned(
                            top: 27,
                            right: 10,
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(52, 177, 170, 10),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'New Branch',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        ClipRRect(
                          child:
                              selectedFile != null && selectedFile!.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(selectedFile!),
                                      width: 80.0,
                                      height: 80.0,
                                    )
                                  : Image.asset(
                                      'assets/file.png',
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
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
                                  // Update the text in the TextField with the file name
                                  _image.text = result.files.single.name;
                                });
                              } else {
                                print('Failed to read file.');
                              }
                            } else {
                              print('User canceled the picker.');
                            }
                          },
                          child: IgnorePointer(
                            child: TextField(
                              controller: _image,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Branch Logo',
                                hintText: 'Select Branch Logo',
                              ),
                              readOnly: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _addid,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Branch ID',
                            hintText: 'Enter Branch ID',
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _addname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Branch Name',
                            hintText: 'Enter Branch Name',
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _tin,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'TIN',
                            hintText: 'Enter TIN',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _addaddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Address',
                            hintText: 'Enter Address',
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            addbranch();
                            print('save');
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(52, 177, 170, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
