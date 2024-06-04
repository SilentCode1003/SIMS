import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../model/modelinfo.dart';
import '../repository/helper.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sims/api/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class Inbox extends StatefulWidget {
  final String usercode;
  const Inbox({super.key, required this.usercode});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  String notificationid = '';
  Helper helper = Helper();
  List<NotificationModel> notification = [];
  List<PushNotificationModel> pushnotification = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    _getnotification();
    _Pushnotification();
    print(widget.usercode);
    Timer.periodic(Duration(seconds: 60), (timer) {
      notification.clear();
      pushnotification.clear();
      _getnotification();
      _Pushnotification();
    });
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      String title, String description, int id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  String _formatDate(String? date) {
    if (date == "" || date == null) return '';
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM', 'en_US').format(dateTime);
  }

  Future<void> _getnotification() async {
    final response = await Notifications().getnotification(widget.usercode);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsonData = json.encode(response.result);
      for (var notificationInfo in json.decode(jsonData)) {
        setState(() {
          NotificationModel notificationInfoModel = NotificationModel(
              notificationInfo['notificationid'].toString(),
              notificationInfo['userid'].toString(),
              notificationInfo['branchid'].toString(),
              notificationInfo['quantity'].toString(),
              notificationInfo['message'].toString(),
              notificationInfo['status'].toString(),
              notificationInfo['checker'].toString(),
              _formatDate(notificationInfo['date'].toString()),
              notificationInfo['productname'].toString(),
              notificationInfo['branch']);
          notification.add(notificationInfoModel);
        });
      }
    }
  }

  Future<void> _Pushnotification() async {
    print('push');
    final response = await Notifications().getnotification(widget.usercode);
    if (helper.getStatusString(APIStatus.success) == response.message) {
      final jsondata = json.encode(response.result);
      for (var pushnotificationInfo in json.decode(jsondata)) {
        if (pushnotificationInfo['checker'].toString() == '0') {
          setState(() {
            PushNotificationModel pushnotif = PushNotificationModel(
                pushnotificationInfo['notificationid'].toString(),
                pushnotificationInfo['userid'].toString(),
                pushnotificationInfo['branchid'].toString(),
                pushnotificationInfo['quantity'].toString(),
                pushnotificationInfo['message'].toString(),
                pushnotificationInfo['status'].toString(),
                pushnotificationInfo['checker'].toString(),
                _formatDate(pushnotificationInfo['date'].toString()),
                pushnotificationInfo['productname'].toString(),
                pushnotificationInfo['branch']);
            pushnotification.add(pushnotif);
          });
          await showNotification(
            pushnotificationInfo['message'].toString(),
            pushnotificationInfo['productname'].toString(),
            pushnotificationInfo['notificationid'],
          );
          await _recievednotification(
              pushnotificationInfo['notificationid'].toString());
        }
      }
    }
  }

  Future<void> _recievednotification(String notificationid) async {
    try {
      final response =
          await Notifications().recievednotification(notificationid);
      if (response.status == 200) {
        print('success $notificationid');
        notification.clear();
        _getnotification();
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error $notificationid');
    }
  }

  Future<void> _readnotification() async {
    try {
      final response = await Notifications().readnotification(notificationid);
      if (response.status == 200) {
        print('success $notificationid');
        notification.clear();
        _getnotification();
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error $notificationid');
    }
  }

  Future<void> _deletenotification(notificationid) async {
    print('delete');
    try {
      final response = await Notifications().deletenotification(notificationid);
      if (response.status == 200) {
        print('success delete $notificationid');
      } else {
        print('hindi success');
      }
    } catch (e) {
      print('error $notificationid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title:
            const Text('Notification', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(52, 177, 170, 10),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notification.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notification[index].notificationid),
                    onDismissed: (direction) {
                      setState(() {
                        // _deletenotification(notification[index].notificationid);
                        notification.removeAt(index);
                        print('ID: ${notification[index].notificationid}');
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        notificationid = notification[index].notificationid;
                        print(notificationid);
                        _readnotification();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                height: 230,
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${notification[index].message}!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      color: Colors.white,
                                      height: 86,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Branch: ${notification[index].branch} (${notification[index].branchid})',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10)),
                                          Text(
                                            'Stocks Alert ${notification[index].productname} is ${notification[index].message}! with Quantity of ${notification[index].quantity}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  52, 177, 170, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              'Okay',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 12, left: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(52, 177, 170, 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 27,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 65, top: 10),
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.7,
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Text(
                                        '${notification[index].branch} (${notification[index].branchid})',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              notification[index].status ==
                                                      'UNREAD'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: Text(
                                        '${notification[index].productname} is ${notification[index].message}! with Quantity of ${notification[index].quantity}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              notification[index].status ==
                                                      'UNREAD'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 0,
                              child: Container(
                                color: Colors.white,
                                height: 60,
                                width:
                                    MediaQuery.of(context).size.width * 0.130,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Text(
                                          notification[index].date,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight:
                                                notification[index].status ==
                                                        'UNREAD'
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        )),
                                    Positioned(
                                      top: 25,
                                      right: 5,
                                      child: Icon(
                                        Icons.brightness_1_rounded,
                                        color: notification[index].status ==
                                                'UNREAD'
                                            ? Colors.red
                                            : Colors.white,
                                        size: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
