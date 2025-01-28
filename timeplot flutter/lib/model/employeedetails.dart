class EmployeeDetails {
  String authToken;
  String userId;
  String message;
  List<String> roles;
  String userName;
  String leadBy;
  String emailId;

  EmployeeDetails(
      {required this.userId,
      required this.authToken,
      required this.message,
      required this.roles,
      required this.userName,
      required this.leadBy,
      required this.emailId});
}
