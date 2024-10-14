import 'package:flutter/material.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:timeplot_flutter/screens/colors.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

 TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: CommonAppBar(
          menuItems: ['Welcome','Ticket', 'Logout'],
          title: 'Products',
          showProfile: true,
          // onProfileTap: () {
          //   print('Profile tapped!');
          // },
        ),
        body: Column(
          children: [
            // SizedBox(height:10),
            //  if (_selectedContact == null)
            Padding(
             
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                // onChanged: _onSearchChanged,
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
            // _selectedContact == null
            //           ? getList()
            //           : getContactDetails(),
          ],
        )
     );
  }
}