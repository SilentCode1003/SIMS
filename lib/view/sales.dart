import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  final String branchid;
  const Sales({super.key, required this.branchid});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String getMonthName(int index) {
    List<String> months = [
      '12 AM',
      '11 AM',
      '10 AM',
      '9 AM',
      '8 AM',
      '7 AM',
      '6 AM',
      '5 AM',
      '4 AM',
      '3 AM',
      '2 AM',
      '1 AM',
      '12 PM',
      '11 PM',
      '10 PM',
      '9 PM',
      '8 PM',
      '7 PM',
      '6 PM',
      '5 PM',
      '4 PM',
      '3 PM',
      '2 PM',
      '1 PM',
    ];
    if (index >= 0 && index < months.length) {
      return months[index];
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.branchid);
  }

  final DateTime _focusDate = DateTime.now();
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('Asvesti - Imus', style: TextStyle(color: Colors.white)),
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
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15.0),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  // height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        print(
                            'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDay)}'); // Format selected date
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  )),
            ),
          ),
          Container(
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 90.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                'Container 1',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 90.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                'Container 1',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
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
          ),
        ],
      ),
    );
  }
}
