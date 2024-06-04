import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'dart:convert';

import '../api/payment.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class PaymentMethod extends StatefulWidget {
  final String fullname;
  final String employeeid;
  const PaymentMethod(
      {super.key, required this.fullname, required this.employeeid});

  @override
  State<PaymentMethod> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PaymentMethod> {
  Helper helper = Helper();
  String paymentcode = '';
  String currentname = '';
  List<PaymentModel> payment = [];
  List<PaymentModel> filterpayment = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _add = TextEditingController();
  TextEditingController _editname = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getpayment();
  }

  Future<void> _getpayment() async {
    final response = await Payment().paymnet();
    if (helper.getStatusString(APIStatus.success) == response.message) {
      setState(() {
        final jsondata = json.encode(response.result);
        for (var paymentinfo in json.decode(jsondata)) {
          PaymentModel paymentinfos = PaymentModel(
            paymentinfo['paymentid'].toString(),
            paymentinfo['paymentname'],
            paymentinfo['status'],
            paymentinfo['createdby'],
            paymentinfo['createddate'],
          );
          payment.add(paymentinfos);
          filterpayment = List.from(payment);
        }
      });
    }
  }

  Future<void> addpayment() async {
    String paymentname = _add.text;

    print('$paymentname');

    try {
      final response = await Payment()
          .savepayment(paymentname, widget.fullname, widget.employeeid);

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

  Future<void> _editpayment() async {
    String paymentname = _editname.text;

    print('$paymentname');

    try {
      final response = await Payment()
          .editpayment(paymentname, paymentcode, widget.employeeid);

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
            text: response.message,
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

  void _filterPayment(String searchText) {
    setState(() {
      filterpayment = payment
          .where((payment) => payment.paymentname
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
        title:
            const Text('Payment Method', style: TextStyle(color: Colors.white)),
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
                        _filterPayment(value);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Payment',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              filterpayment = List.from(payment);
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
                itemCount: filterpayment.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // employeeid = filteredEmployees[index].employeeid;
                      _editname.text = filterpayment[index].paymentname;
                      paymentcode = filterpayment[index].paymentid;
                      currentname = filterpayment[index].paymentname;
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
                                child: Column(children: [
                                  Text(
                                    'Update Payment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          controller: _editname,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Payment Name',
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Payment Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        _editpayment();
                                        // addpayment();
                                        // setState(() {
                                        //   filtercategory.clear();
                                        // });
                                        // _getcategories();
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                52, 177, 170, 10),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  )
                                ]),
                              ));
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
                                  Icons.payment,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 17, left: 75),
                            child: Text(
                              filterpayment[index].paymentname,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 37, left: 75),
                            child: Text(
                              filterpayment[index].paymentid,
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
                    child: Column(children: [
                      Text(
                        'Add Payment Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              controller: _add,
                              decoration: InputDecoration(
                                hintText: 'Enter Payment Name',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Payment Name',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            print('payment');
                            addpayment();
                            // setState(() {
                            //   filtercategory.clear();
                            // });
                            // _getcategories();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(52, 177, 170, 10),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    ]),
                  ));
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
