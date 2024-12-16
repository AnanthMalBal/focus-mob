import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {


// Future<void> _openUrl(String url) async {
//   final Uri uri = Uri.parse(url);

//   if (!await launchUrl(uri)) {
//     print('Could not launch $url'); 
//     throw 'Could not launch $url';
//   } else {
//     print('URL launched: $url');
//   }
// }

Future<void> _openUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (uri.scheme == 'file') {
    // Handle file URLs
    print('Opening file: $url');
    final String path = uri.path;
    try {
      if (await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      )) {
        print('File opened: $path');
      } else {
        print('Could not open file: $path');
      }
    } catch (e) {
      print('Error opening file: $e');
    }
  } else {
    // Handle other types of URLs
    if (!await launchUrl(uri)) {
      print('Could not launch $url');
      throw 'Could not launch $url';
    } else {
      print('URL launched: $url');
    }
  }
}

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       
        // appBar:

        //     CommonAppBar(
        //   menuItems: [],
        //   title: 'QRScanner',

        //   showProfile: true,
        //   // onProfileTap: () {
        //   //   print('Profile tapped!');
        //   // },
        // ),
body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) async {
          print("onDetect triggered");
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;
          // for (final barcode in barcodes) {
          //   print('Barcode found! ${barcode.rawValue}');
          // }
         if (barcodes.isNotEmpty) {
      final String? url = barcodes.first.rawValue;
      if (url != null) {
        print('Barcode found! $url');

        // Try to open the URL
        await _openUrl(url);
      }
    }
          if (image != null) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    barcodes.first.rawValue ?? "",
                  ),
                  content: Image(
                    image: MemoryImage(image),
                  ),
                );
              },
            );
          }
        },
      ),

     );
     
  }
}

