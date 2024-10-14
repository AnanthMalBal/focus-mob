import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeplot_flutter/model/event.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/screens/filltimesheet.dart';
import 'package:timeplot_flutter/services/getholidaysservice.dart';
import 'package:timeplot_flutter/services/sharedpreferences.dart';
import 'package:intl/intl.dart';

final shareddata = SharedPref();

enum SampleItem { itemOne, itemTwo, itemThree }

SharedPreferences? prefs;
List<dynamic> _items = [];
//  List< dynamic> _itemsBalance =[];
List<Map<String, dynamic>> _itemsBalance = [];
List<Map<String, dynamic>> dataColor = [];

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({
    super.key,
  });

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  SampleItem? selectedMenu;

  var _events = {};
  DateTime _focusedDay = DateTime.now();
  List<Event>? date;
  Map<String, dynamic> mapMonths = {};
  String? empId;
  final HolidayService leaveservice = HolidayService();
  Map<DateTime, List<Map<String, dynamic>>> events = {};


  void _onDaySelected(DateTime day, DateTime focusedDay) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_focusedDay);
    print('Selected Date: $formattedDate');

    setState(() {
      _focusedDay = day;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FillTimeSheet(date: _focusedDay),
          ));
    });
  }

  void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.Empid;
      print("id" + empId.toString());
    });
    getLeaves(empId.toString(), _focusedDay.toString());
    getBalanceLeave(empId.toString(), context);
  }

  Future getLeaves(String empId, String today) async {
    print("iddate" + empId + today);
    List<dynamic> posts = await leaveservice.getHolidays(empId, today, context);
    print("data:" + posts.toString());

    setState(() {
      _events = _groupEventsByDate(posts[0]);
      _items = posts[1];
    });
  }

  Map<DateTime, List<dynamic>> _groupEventsByDate(List<dynamic> events) {
    print("events" + events.toString());
    //  print("events"+events[0]['sdate']);
    Map<DateTime, List<dynamic>> groupedEvents = {};
    for (var event in events) {
      if (event is Map<String, dynamic>) {
        DateTime eventDate = DateTime.parse(event['sdate'] as String);
        Color color = _getColorFromString(event['color'] as String);

        if (groupedEvents[eventDate] == null) {
          groupedEvents[eventDate] = [];
        }

        groupedEvents[eventDate]!.add(
            {"date": event['sdate'], "title": event['title'], "color": color});
        // events[date]!.add({"title": event['title'], "color": color})
      }
    }
    print("group" + groupedEvents.toString());
    return groupedEvents;
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    //   print("day"+day.toString());
    // return _events[_stripTime(day)] ?? [];
    final events = _events[_stripTime(day)] ?? [];
    print('Events for $day: $events');
    return events;
  }

  Future getLMSList(context) async {
    print("resultLMS");

    List<dynamic> resultLMS = await leaveservice.getLMS(context);
    print("resultLMS:" + resultLMS.toString());
    setState(() {
      // _items = resultLMS;
    });
  }

  Future getBalanceLeave(String empId, context) async {
    print("resultbalance" + empId);
    List<dynamic> resultBalance =
        await leaveservice.getLeaveBalance(empId, context);
    print("resultbalance:" + resultBalance[0].toString());
    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(resultBalance[0]);
    setState(() {
      _itemsBalance = data;

      // int count =  _itemsBalance['Count'];
      // print("count++"+count.toString());
      // mapMonths.addEntries( _itemsBalance.entries);
      // mapMonths.forEach((key, value) {
      //   print("++++" '$key: $value');
      // });
    });
  }

  @override
  void initState() {
    // user = widget.date;
   
    print("data1");

    super.initState();
    _events = {};
    transferdata();

  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(       
        appBar:
      
            CommonAppBar(
          menuItems: ['Welcome', 'Logout'],
          title: 'Daily Log',
          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        body:
            //  SingleChildScrollView(
            SafeArea(
          child: Column(
            //  mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   padding: new EdgeInsets.all(15.0),

              //   //  width: MediaQuery.of(context).size.width,
              //   //       height: MediaQuery.of(context).size.height/1 ,
              //   width: 500.0,
              //   // height:20.0,
              //   decoration: BoxDecoration(
              //     color: AppColors.borderColor.withOpacity(0.1),
              //     //  borderRadius: BorderRadius.circular(10)
              //   ),
              //   child:
              //       Text("Signed Out:" + _focusedDay.toString().split(" ")[0],
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.w500,
              //           )),
              // ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // Text("HI"),

                        child: TableCalendar(
                          locale: "en_US",
                          rowHeight: 43,
                          //  centerTitle: true,
                          // backgroundColor:Colors.grey,

                          headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              decoration: BoxDecoration(

                                  //  color: Colors.grey.withOpacity(0.5)
                                  ),
                              titleTextStyle: TextStyle(
                                color:AppColors.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          availableGestures: AvailableGestures.all,
                          selectedDayPredicate: (day) =>
                              isSameDay(day, _focusedDay),

                          firstDay: DateTime.utc(2020, 07, 01),
                          lastDay: DateTime.utc(2050, 09, 30),
                          focusedDay: _focusedDay,
                          calendarStyle: CalendarStyle(
                            outsideTextStyle: TextStyle(
                                color: Color.fromARGB(255, 161, 160, 160)),
                            todayDecoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            
                          ),
                          eventLoader: _getEventsForDay,                         

                          calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                            if (events.isNotEmpty) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final _event =
                                        events[index] as Map<String, dynamic>?;
                                    print("++++" + _event.toString());
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _event != null
                                              ? _event['color']
                                              : Colors.transparent
                                          //  Colors.primaries[ Random().nextInt(Colors.primaries.length)],
                                          ),
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    );
                                  });
                            }
                            return null;
                          }),

                          onDaySelected: _onDaySelected,

                          onPageChanged: (focusedDay) {
                            print("print" + focusedDay.month.toString());
                            print("print1" + focusedDay.toString());
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                            getLeaves(empId.toString(), focusedDay.toString());
                            //  getBalanceLeave(empId.toString(),context);
                          },
                        ),
                      )
                    ]),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 5, right: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              new EdgeInsets.only(top: 5.0, left: 5, right: 5),
                          width: 500.0,
                          // height:20.0,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor.withOpacity(0.1),
                            //  borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("This Month",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              )),
                        )
                      ])),
              getList(),
              Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 5, right: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              new EdgeInsets.only(top: 5.0, left: 5, right: 5),
                          width: 500.0,
                          // height:20.0,
                          decoration: BoxDecoration(
                            color: AppColors.borderColor.withOpacity(0.1),
                            //  borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("Your Remain Leave",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              )),
                        )
                      ])),
              leaveBalance()
            ],
          ),
        )
        // )
        );
    // );
  }

  Widget getList() {
    Padding(padding: EdgeInsets.all(15.0));
    return Expanded(
      // child:Text("Hi")

      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _items.length,
          itemBuilder: (BuildContext context, index) {
            var item = _items[index];
            // var colors = [
            //   // _items[index]["colorcode"],
            //   Colors.orange,
            //   Colors.green,
            //   Colors.blue,
            //   Colors.yellow,
            // ];

            // Color color = new Color(0x12345678);
            // String colorString =color.toString(); // Color(0x12345678)
            // String valueString =
            //     colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
            // int value = int.parse( valueString, radix: 16);

            // Color otherColor = new Color(value);
            return Container(
                height: 23,
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 6,
                      backgroundColor: _getColorFromString(item['color']),
                    ),
                    title: Text(_items[index]["title"].toString()),
                    trailing: Text(_items[index]["count"].toString())));
          }),
    );
  }

  Widget leaveBalance() {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _itemsBalance.length,
          itemBuilder: (BuildContext context, index) {
            int count = _itemsBalance[index]['Count'];
            String description = _itemsBalance[index]['Description'];
            return Container(
                height: 23,
                child: ListTile(
                    leading: Text(description),
                    // Text('${mapMonths.keys}'),
                    // title: Text("LWP"),
                    trailing: Text(count.toString())
                    // Text("${mapMonths.values}"),
                    //  minLeadingWidth : 5,
                    ));
          }),
    );
  }

//  Map<DateTime, List<Map<String, dynamic>>> events = {};
  void _mapApiDataToEvents() {
    for (var event in dataColor) {
      DateTime date = DateTime.parse(event['sdate']!);
      Color color = _getColorFromString(event['color']);

      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(
          {"date": event['sdate'], "title": event['title'], "color": color});
    }
  }

  Color _getColorFromString(String? colorString) {
    // if (colorString == null) {
    //   return Colors.blue; // default color if colorString is null
    // }
    switch (colorString) {
      case "Orange":
        return Colors.orange;
      case "Green":
        return Colors.green;
      case "Yellow":
        return Colors.yellow;
      default:
        return Colors.blue; // default color if none matched
    }
  }
}
