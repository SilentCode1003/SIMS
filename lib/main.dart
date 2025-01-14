import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'view/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sims/repository/helper.dart';
import 'package:sims/api/login.dart';
import 'dart:convert';
import 'package:sims/model/modelinfo.dart';
import 'package:sims/view/gridview.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String domain = '';

  @override
  void initState() {
    super.initState();
    _getDomain();
  }

  Future<void> _getDomain() async {
    Map<String, dynamic> userinfo = {};
    if (Platform.isWindows) {
      userinfo = await Helper().readJsonToFile('server.json');
    }

    if (Platform.isAndroid) {
      userinfo = await JsonToFileRead('server.json');
    }

    DomainModel user = DomainModel(
      userinfo['domain'].toString(),
    );

    print(userinfo['domain']);
    setState(() {
      domain = user.domain;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asvesti',
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: false,
      ),
      home: (domain.isEmpty) ? const DomainPage() : const OpeningPage(),
      routes: {'/logout': ((context) => const LoginPage())},
    );
  }
}

class OpeningPage extends StatefulWidget {
  const OpeningPage({super.key});

  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  void initState() {
    super.initState();
    _loadLoginPage();
  }

  Future<void> _loadLoginPage() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 300,
              child: Column(
                children: [
                  Image.asset('assets/asvesti.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Container(
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(52, 177, 170, 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  _DomainPage createState() => _DomainPage();
}

class _DomainPage extends State<DomainPage> {
  bool isLoading = false;
  final TextEditingController _DomainController = TextEditingController();
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _domain(BuildContext context) async {
    createJsonFile('server.json');
    String domain = _DomainController.text;

    print(domain);

    if (domain.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please input server IP Address / domain host'),
        ),
      );
    } else {
      try {
        if (Platform.isWindows) {
          await helper.writeJsonToFile({'domain': domain}, 'server.json').then(
              (result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Domain saved successfully!'),
              ),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OpeningPage(),
              ),
            );
          });
        }

        if (Platform.isAndroid) {
          await JsonToFileWrite({'domain': domain}, 'server.json')
              .then((result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Domain saved successfully!'),
              ),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OpeningPage(),
              ),
            );
          });
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save domain!'),
          ),
        );
      }
    }
  }

  Future<void> createJsonFile(filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final filePath = '${directory.path}/$filename';

      final File file = File(filePath);

      if (file.existsSync()) {
        return;
      }
      Map<String, dynamic> jsonData = {};
      if (filename == 'server.json') {
        jsonData = {'domain': ''};
      }

      final jsonString = jsonEncode(jsonData);
      file.writeAsStringSync(jsonString);

      print('JSON file created successfully at: $filePath');
    } catch (e) {
      print('Error creating JSON file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(52, 177, 170, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 75.0),
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/file.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 280.0),
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 300),
                  child: Text(
                    'Lon in to your domain',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(52, 177, 170, 10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 350),
                  child: TextField(
                    controller: _DomainController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Domain',
                      hintText: 'Enter Domain',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 420),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(52, 177, 170, 10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _domain(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(width: 10),
                              ],
                            )
                          : const Text(
                              'Enter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Helper helper = Helper();

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  Future<void> _loadRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  Future<void> _saveRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Login().login(username, password);

      if (helper.getStatusString(APIStatus.success) == response.message) {
        final jsonData = json.encode(response.result);
        for (var userinfo in json.decode(jsonData)) {
          helper.writeJsonToFile(userinfo, 'user.json');
        }
        _saveRememberedCredentials();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => Index(
                    selectedIndex: 0,
                  )),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Access'),
            content: const Text('Incorrect username and password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to connect to the server. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  isLoading = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(52, 177, 170, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 75.0),
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/file.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 280.0),
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 300),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(52, 177, 170, 10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 370),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter valid Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 440),
                  child: TextField(
                    obscureText: _isPasswordObscured,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 505),
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(52, 177, 170, 10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const Index(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(width: 10),
                              ],
                            )
                          : const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 560),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DomainPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
