import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../repository/helper.dart';
import 'package:sims/api/login.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class ChangePassword extends StatefulWidget {
  final String usercode;
  final String employeeid;
  const ChangePassword(
      {super.key, required this.usercode, required this.employeeid});

  @override
  State<ChangePassword> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChangePassword> {
  String employeeid = '';
  bool isLoading = false;

  Helper helper = Helper();

  late TextEditingController OldPasswordController;
  late TextEditingController NewPasswordController;
  late TextEditingController ConfirmPasswordController;

  bool _isPasswordObscuredold = true;
  bool _isPasswordObscurednew = true;
  bool _isPasswordObscuredconfirm = true;

  String _passwordError = ''; // Store the password validation error

  FocusNode confirmPasswordFocusNode = FocusNode();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscuredold = !_isPasswordObscuredold;
    });
  }

  void _togglenewPasswordVisibility() {
    setState(() {
      _isPasswordObscurednew = !_isPasswordObscurednew;
    });
  }

  void _toggleconfirmPasswordVisibility() {
    setState(() {
      _isPasswordObscuredconfirm = !_isPasswordObscuredconfirm;
    });
  }

  String _validatePassword(String newPassword, String confirmPassword) {
    if (newPassword != confirmPassword) {
      return 'Passwords do not match';
    }
    return '';
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _changepass() async {
    String currentpassword = oldPasswordController.text;
    String newpassword = newPasswordController.text;
    String confirmPass = ConfirmPasswordController.text;

    print('$currentpassword $newpassword $confirmPass');

    if (newpassword != confirmPass) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('New and confirm passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Ask for confirmation
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to change your password?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!confirm) {
      return;
    }

    try {
      final response = await Login().changepass(
          currentpassword, newpassword, widget.usercode, widget.employeeid);
      print(response.message);

      if (response.message == 'success') {
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
            title: "Incorrect Current Password",
          ),
        ).then((_) {});
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

  @override
  void initState() {
    super.initState();
    OldPasswordController = TextEditingController();
    NewPasswordController = TextEditingController();
    ConfirmPasswordController = TextEditingController();
    confirmPasswordFocusNode.addListener(() {
      if (!confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _passwordError = _validatePassword(
            newPasswordController.text,
            confirmPasswordController.text,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:
            const Text('Product List', style: TextStyle(color: Colors.white)),
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
      backgroundColor: Colors.white,
      body: Form(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35.0, left: 90, right: 0),
              child: SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('assets/icon.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 220, left: 20),
              child: Text(
                'Current Password',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 248,
                bottom: 15,
              ),
              child: TextField(
                controller: oldPasswordController,
                obscureText: _isPasswordObscuredold,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter secure Current password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscuredold
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _togglePasswordVisibility();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 325, left: 20),
              child: Text(
                'New Password',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 355,
                bottom: 15,
              ),
              child: TextField(
                controller: newPasswordController,
                obscureText: _isPasswordObscurednew,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Enter new password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscurednew
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _togglenewPasswordVisibility();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 430, left: 20),
              child: Text(
                'Confirm Password',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 460,
                bottom: 15,
              ),
              child: TextField(
                controller: ConfirmPasswordController,
                obscureText: _isPasswordObscuredconfirm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Confirm password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscuredconfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _toggleconfirmPasswordVisibility();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 540, left: 20, right: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(52, 177, 170, 10),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _changepass();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
                  ),
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                          ],
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
