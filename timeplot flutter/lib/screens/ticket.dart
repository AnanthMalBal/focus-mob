import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:timeplot_flutter/screens/productdetails.dart';
import 'package:timeplot_flutter/screens/ticketraising.dart';
import 'package:timeplot_flutter/services/customerlistservice.dart';



SharedPreferences? prefs;

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  
  String query = "";

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];

  Timer? _debounce;
  final CustomerListService customerservice = CustomerListService();
Map<String, dynamic>? _selectedContact;


  @override
  void initState() {
    super.initState();

    // transferdata();
  }

  Future<void> _fetchContacts(String text) async {
    print("resultphonenumber");
    setState(() {});
    Map<String, dynamic> resultPhoneneumber = await customerservice
        .getPhonenumberList(_searchController.text, context);
    print("resultPhoneneumber:" + resultPhoneneumber.toString());
// Get the message and result
    // String message = resultPhoneneumber['message'];
    List<dynamic> customerList = resultPhoneneumber['result'];

    // Iterate over the customerList
    for (var customer in customerList) {
      String customerId = customer['customerId'];
      String customerName = customer['customerName'];

      print('Customer ID: $customerId, Customer Name: $customerName');
    }
    setState(() {
      _contacts = customerList.map((item) {
        return {
          'name': item['customerName'].toString(),
          'phone': item['mobileNumber'].toString(),
        };
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    // Cancel the previous timer if it's still active
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Create a new timer (debounce) that delays the API call by 500ms
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _fetchContacts(query);
      } else {
        setState(() {
          _contacts = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce
        ?.cancel(); // Cancel any active debouncing timers when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          menuItems: ['Welcome', 'Logout'],
          title: 'Ticketing',
          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        body: 
        Column(
          children: [
            // SizedBox(height:10),
             if (_selectedContact == null)
            Padding(
             
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  labelText: "Search Customer",
                  labelStyle: TextStyle(
                    color: AppColors
                        .textColor, 
                      fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _selectedContact == null
                      ? getList()
                      : getContactDetails(),
          ],
        ));
  }

  Widget getList() {
    return Expanded(
      child: _contacts.isNotEmpty
          ? ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                  child: ListTile(
                      title: Text(_contacts[index]['name'].toString()),
                      subtitle: Text(_contacts[index]['phone'].toString()),

                      // trailing:Text(_contacts[index]['customerId'].toString()),
                      onTap: () {
                        print("click");
                        setState(() {
                           if (_selectedContact == index) {
                              _selectedContact = null; // Collapse details when tapped again
                            } else {
                              _selectedContact =  _contacts[index]; // Expand details for the tapped item
                            }
                        // _selectedContact = _contacts[index];
                      });
                      }),
                );
              })
          : Center(
              child: Text(
              "No Result",
              style: TextStyle(fontSize: 20),
            )),
    );
  }



Widget getContactDetails() {
  return Column(
    children: [
      // Display the selected contact's name and phone
      if (_selectedContact != null) 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${_selectedContact!['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Phone: ${_selectedContact!['phone']}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      
      // ListView builder with additional details
      Container(
        height: 300, // Adjust height if needed
        child: ListView.builder(
          itemCount: 5, // Example data length
          itemBuilder: (BuildContext context, index) {
            return Card(
              child: ListTile(
                title: Text("Sample Detail $index"),
                subtitle: Text("Sample Description $index"),
                onTap: () {
                  print("click2");
                  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketRaisingScreen(),
          ));
                  setState(() {
                    // Handle the tap, update contact or perform an action
                  });
                },
              ),
            );
          },
        ),
      ),
      
      SizedBox(height: 16), // Spacing between the ListView and the button
      ElevatedButton(
        onPressed: () {
          // Reset the selected contact (or the index) to null
          setState(() {
            _selectedContact = null; // Clears the detail view and goes back to the search
          });
        },
        child: Text('Back to Search'),
      ),
    ],
  );
}

}
