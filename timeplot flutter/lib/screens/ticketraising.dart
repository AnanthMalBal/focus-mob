import 'package:flutter/material.dart';
import 'package:timeplot_flutter/screens/appbar.dart';

class TicketRaisingScreen extends StatefulWidget {
  const TicketRaisingScreen({super.key});

  @override
  State<TicketRaisingScreen> createState() => _TicketRaisingScreenState();
}

class _TicketRaisingScreenState extends State<TicketRaisingScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: CommonAppBar(
          menuItems: ['Welcome','Ticket', 'Logout'],
          title: 'TicketRaising',
          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
     );
  }
}