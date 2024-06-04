import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:sims/main.dart';
import 'package:sims/view/branch_list.dart';
import 'package:sims/view/category_list.dart';
import 'package:sims/view/employee_list.dart';
import 'package:sims/view/password.dart';
import 'package:sims/view/payment_list.dart';
import 'package:sims/view/product_item.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'package:sims/view/notification.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String employeeid = '';
  String fullname = '';
  String position = '';
  String usercode = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    Map<String, dynamic> userinfo = await Helper().readJsonToFile('user.json');
    UserModel user = UserModel(
      userinfo['employeeid'].toString(),
      userinfo['fullname'].toString(),
      userinfo['position'].toString(),
      userinfo['contactinfo'].toString(),
      userinfo['datehired'].toString(),
      userinfo['usercode'].toString(),
      userinfo['accesstype'].toString(),
      userinfo['positiontype'].toString(),
      userinfo['status'].toString(),
    );

    setState(() {
      employeeid = user.employeeid;
      fullname = user.fullname;
      position = user.position;
      usercode = user.usercode;

      print('usercode: $usercode');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Inbox(
                          usercode: usercode,
                        ),
                      ),
                    );
                  },
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
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  'assets/file.png',
                  fit: BoxFit.cover,
                  width: 60.0,
                  height: 60.0,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 90,
              child: Text(
                fullname,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 90,
              child: Text(
                'Owner',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(52, 177, 170, 10),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 170,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Product');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductList(
                        fullname: fullname,
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.assignment_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Product List',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Employee');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Employee(
                        fullname: fullname,
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.person_outline_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Employee',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 310,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Branch');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Branch(
                        employeeid: employeeid,
                        fullname: fullname,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.store_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Branch',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 380,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Category');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryList(
                        fullname: fullname,
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.auto_awesome_mosaic_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Category',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 450,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Payment');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentMethod(
                        fullname: fullname,
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.payment_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Payment Method',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 520,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  print('Password');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(
                        usercode: usercode,
                        employeeid: employeeid,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.lock_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Password',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 590,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        title: const Center(
                          child: Text(
                            'Are you sure want to log out?',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        actions: [
                          SizedBox(
                            width: 120,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'No',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 40,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(52, 177, 170, 10)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(52, 177, 170, 0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.logout_outlined,
                              color: Color.fromRGBO(52, 177, 170, 10),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 13,
                          left: 60,
                          child: Text(
                            'Logout',
                            style: TextStyle(fontSize: 18),
                          )),
                      Positioned(
                          top: 13,
                          right: 0,
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
