import 'package:flutter/material.dart';
import 'package:focusontime/modules/lms/screens/applyleave.dart';
import 'package:focusontime/services/customerlistservice.dart';



class TicketRaisingScreen extends StatefulWidget {
  const TicketRaisingScreen({super.key});

  @override
  State<TicketRaisingScreen> createState() => _TicketRaisingScreenState();
}

class _TicketRaisingScreenState extends State<TicketRaisingScreen> {

final CustomerListService customerservice = CustomerListService();
List<dynamic> customerList=[];
 bool isLoadingMore = false;
 bool hasMore = true; // 
  int currentPage = 1; // Track the current page
   final int pageSize = 10; // Show only 10 items per page
 int displayLimit = 10; // Limit displayed items to 10 initially 
 var empId;
 var roles;


void transferdata() async {
    final empData = await shareddata.getpatdata();
    setState(() {
      empId = empData.userId;
      roles=empData.roles;
      print("id" + empId.toString());
    });
  }

@override
  void initState() {
    super.initState();
    _fetchList();
    
     transferdata();
  }

 

// Future<void> _fetchList() async {
//   print("Fetching customer list");
  
//   final result = await customerservice.getList(context);  // The result will be a Map
//   print("Result from service: " + result.toString());

//   // Check if the 'result' key exists in the Map and extract the List
//   setState(() {
//     if (result is Map<String, dynamic> && result.containsKey('result')) {
//       customerList = result['result'] as List<dynamic>;
//     } else {
//       customerList = [];  // Handle cases where 'result' might not exist or be empty
//     }
//   });

//   print("Customer List: " + customerList.toString());
// }


 Future<void> _fetchList({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => isLoadingMore = true);
    }
    
    final result = await customerservice.getList(context, page: currentPage, pageSize: pageSize);
    print("Result from service: " + result.toString());

    setState(() {
      if (result is Map<String, dynamic> && result.containsKey('result')) {
        List<dynamic> fetchedList = result['result'] as List<dynamic>;
        
        if (fetchedList.isNotEmpty) {
          if (loadMore) {
            customerList.addAll(fetchedList);
          } else {
            customerList = fetchedList;
          }
          currentPage++;
        } else {
          hasMore = false; // No more items to load
        }
      }
      isLoadingMore = false;
    });

    print("Customer List: " + customerList.toString());
  }

  void _loadMoreItems() {
    setState(() {
      displayLimit += pageSize; // Increase the limit by 10 items
    });
  }

  @override
  Widget build(BuildContext context) {

    
     return Scaffold(
      //  appBar: CommonAppBar(
      //     menuItems: menuItems,
      //     title: 'TicketRaising',
         
      //     showProfile: true,
      //     // onProfileTap: () {
      //     //   print('Profile tapped!');
      //     // },
      //   ),
        //  body: customerList.isEmpty
        //   ? Center(child: CircularProgressIndicator())  // Show loading indicator when list is empty
        //   : ListView.builder(
        //       itemCount: customerList.length,
        //       itemBuilder: (context, index) {
        //         // Accessing the item at 'index'
        //         final product = customerList[index];

        //         // Rendering each item in the list
        //         return ListTile(
        //           title: Text(product['productName']),
        //           subtitle: Text(product['productDescription']),
        //           trailing: Text(product['productId']),
        //         );
        //       },
        //     ),
       body:  customerList.isEmpty && !isLoadingMore
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: (displayLimit < customerList.length ? displayLimit : customerList.length) + 1,
              itemBuilder: (context, index) {
                if (index == displayLimit && displayLimit < customerList.length) {
                  // Show "Load More" button after the displayed items
                  return Center(
                    child: isLoadingMore
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              if (!isLoadingMore && hasMore) {
                                _loadMoreItems();
                              }
                            },
                            child: Text("Load More"),
                          ),
                  );
                }

                if (index >= customerList.length) {
                  return SizedBox(); // Return empty if index is out of range
                }

                final product = customerList[index];
                return ListTile(
                  title: Text(product['productName']),
                  subtitle: Text(product['productDescription']),
                  trailing: Text(product['productId']),
                );
              },
            ),
     );
  }
}