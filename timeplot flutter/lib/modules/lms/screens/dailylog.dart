import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';

class Dailylog extends StatefulWidget {
  final List<Map<String, dynamic>> resultMenu; 
  const Dailylog({super.key ,required this.resultMenu,});
  

  @override
  State<Dailylog> createState() => _DailylogState();
}

class _DailylogState extends State<Dailylog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:         
          CommonAppBar(
        menuItems: widget.resultMenu,
         title: 'DailyLog',
        showProfile: true,       
       ),
      body:Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left:20,right:20,top:10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
          _addTaskBar(),
         _addTaskBarButton(),
           
              ],
            ),
          ),
           Container(
               child: SizedBox(
    height: 80,
    width: MediaQuery.of(context).size.width, 
              child:DatePicker(
                DateTime.now().subtract(Duration(days: 7)),
                height:80,
                width:80,
                initialSelectedDate: DateTime.now(),
                selectionColor: AppColors.primaryColor,
                selectedTextColor: AppColors.backgroundColor,
                dateTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:AppColors.borderColor
                ),
                onDateChange: (date) {
        // Validation to limit user to the 7-day range
        if (date.isBefore(DateTime.now().subtract(Duration(days: 7))) ||
            date.isAfter(DateTime.now().add(Duration(days: 7)))) {
          print('Date out of range');
          return;
        }
        print('Selected date: $date');
      },
      daysCount: 21,
              )
            ),
            ),
        ],
      )
    );
  }
  _addTaskBar(){
    return Container(
                  // margin:const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.yMMMMd().format(DateTime.now()),
                      style:subHeadingStyle,
                      ),
                      Text("Today",
                      style:headingStyle,
                      ),
                    ],
                  ),
                );
  }
  _addTaskBarButton(){
    return  Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  //padding:EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CalenderScreen(resultMenu: widget.resultMenu),
                      //     ));
                     print("text");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
            Icon(
              Icons.add, 
              color: AppColors.backgroundColor,
            ),
            SizedBox(width: 5), // Space between the icon and text
            Text(
              "Add Task",
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
                    ],
                  ),
                    ),
                  ),
                );
            
  }
}