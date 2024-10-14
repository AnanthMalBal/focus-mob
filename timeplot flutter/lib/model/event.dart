// class Event {
//   final DateTime date;
//   final String text;
//   // final String color;

//   Event({
//     required this.date, 
//     required this.text,
//     // required this.color
//     });

//   factory Event.fromJson(Map<dynamic, dynamic> json) {
//     return Event(
//       date: DateTime.parse(json['date']),
//       text: json['text'],
//       // color: json['color'],
//     );
//   }
 
// }


import 'dart:ui';

class Event {
  final String title;
  final Color color;

  Event(this.title, this.color);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['title'],
      Color(int.parse(json['color'].replaceFirst('#', '0xff'))), // Convert hex color to Color
    );
  }
}


