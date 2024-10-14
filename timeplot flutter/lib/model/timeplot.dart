class TimePlotData{
  //data Type
  
  String? text;
  String? colorcode;
  String? remainDays;
  DateTime? date;
// constructor
 TimePlotData(
      {
      
     required this.text,
      required this.colorcode,
     required this.remainDays,
    required this.date,
      }
   );
  //method that assign values to respective datatype vairables
  TimePlotData.fromJson(Map<String,dynamic> json)
  {
    
    text =json['text'];
    colorcode = json['colorcode'];
    remainDays = json['remainDays'];
    date= DateTime.parse(json['date']);
  }
}