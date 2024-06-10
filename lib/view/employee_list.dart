import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../api/employee.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Employee extends StatefulWidget {
  final String fullname;
  final String employeeid;
  const Employee({Key? key, required this.fullname, required this.employeeid})
      : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  bool readonly = true;
  bool saveButtonEnabled = false;
  bool saveButtondetails = false;
  String employeeid = '';
  String positioncode = '';
  Helper helper = Helper();
  List<EmployeeModel> employeelist = [];
  List<EmployeeModel> filteredEmployees = [];
  List<PositionModel> position = [];
  List<String> _positionSuggestions = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _employeeid = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _position = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _datehired = TextEditingController();
  TextEditingController _addname = TextEditingController();
  TextEditingController _addposition = TextEditingController();
  TextEditingController _addcontact = TextEditingController();
  TextEditingController _adddatehired = TextEditingController();
  TextEditingController _editname = TextEditingController();
  TextEditingController _editposition = TextEditingController();
  TextEditingController _editcontact = TextEditingController();
  TextEditingController _editdatehired = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getemployees();
    _getposition();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _adddatehired.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void editbtnemployee() {
    setState(() {
      saveButtonEnabled = true;
    });
  }

  Future<void> _getposition() async {
    final response = await Employees().position();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsonData = json.encode(response.result);
      for (var positionInfo in json.decode(jsonData)) {
        setState(() {
          PositionModel positionInfoModel = PositionModel(
            positionInfo['positioncode'].toString(),
            positionInfo['positionname'].toString(),
            positionInfo['status'],
            positionInfo['createdby'],
            positionInfo['createddate'],
          );
          position.add(positionInfoModel);
          _positionSuggestions.add(positionInfoModel.positionname);
        });
      }
    }
  }

  Future<void> _getemployees() async {
    final response = await Employees().employee();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var employeeinfo in json.decode(jsondata)) {
        setState(() {
          EmployeeModel employeeinfos = EmployeeModel(
            employeeinfo['employeeid'].toString(),
            employeeinfo['fullname'].toString(),
            employeeinfo['position'].toString(),
            employeeinfo['positionname'].toString(),
            employeeinfo['contact'].toString(),
            employeeinfo['datehired'].toString(),
            employeeinfo['createddate'].toString(),
          );
          employeelist.add(employeeinfos);
          filteredEmployees = List.from(employeelist);
        });
      }
    }
  }

  void _filterEmployees(String searchText) {
    setState(() {
      filteredEmployees = employeelist
          .where((employee) => employee.fullname
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> addemployee() async {
    String fullname = _addname.text;
    String contactinfo = _addcontact.text;
    String positionname = _editposition.text;
    String datehired = _adddatehired.text;
    String createdby = widget.fullname;

    try {
      final response = await Employees().addemployee(fullname, positioncode,
          contactinfo, datehired, createdby, widget.employeeid);

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

  Future<void> editemployee() async {
    String fullname = _editname.text;
    String positionname = _editposition.text;
    String contactinfo = _editcontact.text;

    try {
      final response = await Employees()
          .editemployee(employeeid, positioncode, contactinfo, fullname);

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

  void _showmodaldetail(BuildContext context) {
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
                    'Employee Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _editname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name',
                    ),
                    readOnly: readonly,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _editposition,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Position',
                      hintText: 'Enter Position',
                    ),
                    readOnly: readonly,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _editcontact,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Contact',
                      hintText: 'Enter Contact Info',
                    ),
                    readOnly: readonly,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _editdatehired,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Date Hired',
                      hintText: 'Enter Date Hired',
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(52, 177, 170, 1),
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: Color.fromRGBO(52, 177, 170, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            readonly = false;
                            saveButtonEnabled = true;
                          });
                          print(saveButtonEnabled);
                          Navigator.pop(context);
                          _showmodaledit(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(52, 177, 170, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showmodaledit(BuildContext context) {
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
                    'Update Employee',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _editname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name',
                    ),
                    // readOnly: readonly,
                  ),
                  SizedBox(height: 15),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _editposition,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Position',
                        hintText: 'Enter Position',
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      return _positionSuggestions.where(
                        (item) =>
                            item.toLowerCase().contains(pattern.toLowerCase()),
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      var selectedPosition = position.firstWhere(
                          (element) => element.positionname == suggestion);

                      positioncode = selectedPosition.positioncode;
                      print(selectedPosition.positioncode);

                      _editposition.text = suggestion;
                    },
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _editcontact,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Contact',
                      hintText: 'Enter Contact Info',
                    ),
                    // readOnly: readonly,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _editdatehired,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Date Hired',
                      hintText: 'Enter Date Hired',
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            readonly = false;
                            saveButtonEnabled = true;
                          });
                          print(saveButtonEnabled);
                          Navigator.pop(context);
                          _showmodaldetail(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(52, 177, 170, 1),
                            ),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromRGBO(52, 177, 170, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: saveButtonEnabled ? editbtnemployee : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(52, 177, 170, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
                          child: Center(
                            child: Text(
                              'Save',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isSubmitDisabled() {
      return _addname.text.isEmpty ||
          _addposition.text.isEmpty ||
          _addcontact.text.isEmpty ||
          _adddatehired.text.isEmpty;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Employee', style: TextStyle(color: Colors.white)),
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
                        _filterEmployees(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Employee',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              filteredEmployees = List.from(employeelist);
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
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      employeeid = filteredEmployees[index].employeeid;
                      _editname.text = filteredEmployees[index].fullname;
                      _editposition.text =
                          filteredEmployees[index].positionname;
                      _editcontact.text = filteredEmployees[index].contact;
                      _editdatehired.text = filteredEmployees[index].datehired;
                      _showmodaldetail(context);
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
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 17, left: 75),
                            child: Text(
                              filteredEmployees[index].fullname,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 37, left: 75),
                            child: Text(
                              filteredEmployees[index].positionname,
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
                          'New Employee',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _addname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Full Name',
                            hintText: 'Enter Full Name',
                          ),
                        ),
                        SizedBox(height: 15),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _addposition,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Position',
                              hintText: 'Enter Position',
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return _positionSuggestions.where(
                              (item) => item
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()),
                            );
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            // Find the position model with the selected position name
                            var selectedPosition = position.firstWhere(
                                (element) =>
                                    element.positionname == suggestion);
                            // Set the position code
                            positioncode = selectedPosition.positioncode;
                            print(selectedPosition.positioncode);

                            // Set the selected suggestion to the text field
                            _addposition.text = suggestion;
                          },
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _addcontact,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Contact',
                            hintText: 'Enter Contact Info',
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _adddatehired,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Date Hired',
                            hintText: 'Enter Date Hired',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          height:
                              50.0, // You can change this to the desired height
                          child: ElevatedButton(
                            onPressed: _isSubmitDisabled()
                                ? null
                                : () {
                                    addemployee();
                                    _addname.clear();
                                    _addposition.clear();
                                    _addcontact.clear();
                                    _adddatehired.clear();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isSubmitDisabled()
                                  ? Colors.black12
                                  : const Color.fromRGBO(52, 177, 170, 1),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
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
