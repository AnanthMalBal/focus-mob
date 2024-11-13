// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:timeplot_flutter/screens/appbar.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   State<ScannerScreen> createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {


// // Future<void> _openUrl(String url) async {
// //   final Uri uri = Uri.parse(url);

// //   if (!await launchUrl(uri)) {
// //     print('Could not launch $url'); 
// //     throw 'Could not launch $url';
// //   } else {
// //     print('URL launched: $url');
// //   }
// // }

// Future<void> _openUrl(String url) async {
//   final Uri uri = Uri.parse(url);

//   if (uri.scheme == 'file') {
//     // Handle file URLs
//     print('Opening file: $url');
//     final String path = uri.path;
//     try {
//       if (await launchUrl(
//         uri,
//         mode: LaunchMode.platformDefault,
//       )) {
//         print('File opened: $path');
//       } else {
//         print('Could not open file: $path');
//       }
//     } catch (e) {
//       print('Error opening file: $e');
//     }
//   } else {
//     // Handle other types of URLs
//     if (!await launchUrl(uri)) {
//       print('Could not launch $url');
//       throw 'Could not launch $url';
//     } else {
//       print('URL launched: $url');
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//      return Scaffold(
       
//         appBar:

//             CommonAppBar(
//           menuItems: ['Welcome', 'Logout'],
//           title: 'QRScanner',

//           showProfile: true,
//           // onProfileTap: () {
//           //   print('Profile tapped!');
//           // },
//         ),
// body: MobileScanner(
//         controller: MobileScannerController(
//           detectionSpeed: DetectionSpeed.noDuplicates,
//           returnImage: true,
//         ),
//         onDetect: (capture) async {
//           print("onDetect triggered");
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           // for (final barcode in barcodes) {
//           //   print('Barcode found! ${barcode.rawValue}');
//           // }
//          if (barcodes.isNotEmpty) {
//       final String? url = barcodes.first.rawValue;
//       if (url != null) {
//         print('Barcode found! $url');

//         // Try to open the URL
//         await _openUrl(url);
//       }
//     }
//           if (image != null) {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text(
//                     barcodes.first.rawValue ?? "",
//                   ),
//                   content: Image(
//                     image: MemoryImage(image),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),

//      );
     
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart' as pdf_render;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      print('Could not launch $url');
      throw 'Could not launch $url';
    } else {
      print('URL launched: $url');
    }
  }

  Future<String> getFilePathFromUri(Uri uri) async {
    try {
      // Only work with content:// URIs for this case
      if (uri.scheme == 'content') {
        final String? filePath = await _getFilePathFromContentUri(uri);
        if (filePath != null) {
          return filePath;
        }
      }

      // Handle non-content URIs (e.g., file:// URIs)
      return uri.path ?? '';
    } on PlatformException catch (e) {
      print("Error resolving URI: $e");
      throw e;
    }
  }

  Future<String?> _getFilePathFromContentUri(Uri uri) async {
    final directory = await getTemporaryDirectory();
    final fileName = uri.pathSegments.last;
    final file = File('${directory.path}/$fileName');

    // Copy the content from the URI to a local file
    try {
      final byteData = await NetworkAssetBundle(uri).load(uri.path);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.path;
    } catch (e) {
      print("Failed to load content URI: $e");
      return null;
    }
  }

  Future<void> _pickPdfAndScanQrCode() async {
    try {
      // Allow user to pick a PDF file
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        initialDirectory: '/storage/emulated/0/Download', // Emulator's Downloads directory
      );

      if (result != null) {
        final File pdfFile = File(result.files.single.path!);

        // Convert the URI to a file path for processing
        final filePath = await getFilePathFromUri(Uri.parse(pdfFile.path));

        // Open the PDF document using the pdf_render package
        final pdf_render.PdfDocument document = await pdf_render.PdfDocument.openFile(filePath);

        for (int i = 1; i <= document.pageCount; i++) {
          final pdf_render.PdfPage page = await document.getPage(i);
          final int pageWidth = page.width.toInt();
          final int pageHeight = page.height.toInt();
          final pdf_render.PdfPageImage pageImage = await page.render(
            width: pageWidth,
            height: pageHeight,
          );

          final Uint8List imageBytes = pageImage.pixels.buffer.asUint8List();

          // You can now pass the imageBytes to QR code scanning logic
          final BarcodeCapture? barcodeCapture = await MobileScannerController().analyzeImage(filePath);

          if (barcodeCapture != null && barcodeCapture.barcodes.isNotEmpty) {
            final String? url = barcodeCapture.barcodes.first.rawValue;
            if (url != null) {
              print('QR Code found: $url');
              await _openUrl(url);
              return; // Stop scanning after finding the first QR code
            }
          }

          // await page.close();
        }

        print('No QR code found in the PDF.');
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error processing PDF or scanning QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF QR Scanner'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickPdfAndScanQrCode,
            child: Text('Choose PDF from Downloads'),
          ),
        ],
      ),
    );
  }
}