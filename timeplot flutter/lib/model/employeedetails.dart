class EmployeeDetails {
  String accesstoken;
  String userId;
  String message;
  List<String> roles;
  
  EmployeeDetails(
      {
        required this.userId, 
      
      required this.accesstoken,
      required this.message,
      required this.roles
      
      });
}