import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:pdf_render/pdf_render.dart' as pdf_render ;
import 'package:pdf_render/pdf_render.dart'  ;
import 'package:pdf/pdf.dart' as pdf; // Add alias for pd
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; 




class Qrcodescan extends StatefulWidget {
  const Qrcodescan({super.key});

  @override
  State<Qrcodescan> createState() => _QrcodescanState();
}

class _QrcodescanState extends State<Qrcodescan> {

  String? qrCodeData;

// Function to pick PDF file, extract image, and decode QR
Future<void> pickPDFAndScanQRCode() async {
  try {
    // Let the user pick a PDF file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      print("Selected PDF file path: $filePath");

      // Extract image from the PDF (first page for this example)
      final imageBytes = await extractImageFromPDF(filePath);

      if (imageBytes != null && imageBytes.isNotEmpty) {
        // Save the extracted image to a file
        final imageFile = await saveImageToFile(imageBytes);

        // Decode the QR code from the saved image file
        final qrData = await decodeQRCodeFromImage(imageFile);

        setState(() {
          qrCodeData = qrData; // Display or process the decoded QR data
        });
      } else {
        print("Failed to extract a valid image from PDF.");
      }
    } else {
      print("No PDF file selected");
    }
  } catch (e) {
    print("Error processing PDF: $e");
  }
}

// Function to extract image from the first page of the PDF
Future<Uint8List?> extractImageFromPDF(String pdfPath) async {
  try {
    final doc = await pdf_render.PdfDocument.openFile(pdfPath);
    final page = await doc.getPage(1); // Get the first page
    final pageImage = await page.render(width: 500, height: 500); // Render image
    final imageBytes = pageImage.pixels; // Use 'pixels' to get the image as bytes

    // Debugging: Check if the image is extracted correctly
    if (imageBytes.isNotEmpty) {
      print("Image extracted successfully from PDF.");
    } else {
      print("Failed to extract image: Image bytes are empty.");
    }

    return imageBytes;
  } catch (e) {
    print("Error extracting image from PDF: $e");
  }
  return null;
}

// Function to save the extracted image as a file
Future<File> saveImageToFile(Uint8List imageBytes) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/extracted_image.png';
  final file = File(filePath);
  await file.writeAsBytes(imageBytes);

  print("Image saved at: $filePath");
  return file;
}

// Function to decode QR code from an image file
Future<String?> decodeQRCodeFromImage(File imageFile) async {
  try {
    final qrData = await QrCodeToolsPlugin.decodeFrom(imageFile.path);
    return qrData; // Return the decoded data
  } catch (e) {
    print("Error decoding QR code: $e");
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: CommonAppBar(
      //   menuItems: [],
      //   title: 'QRCodeScan',
      //   showProfile: true,
      //   // onProfileTap: () {
      //   //   print('Profile tapped!');

      //   // },
      // ),
 body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickPDFAndScanQRCode,
              child: const Text('Choose PDF to Scan QR Code'),
            ),
            const SizedBox(height: 20),
            if (qrCodeData != null)
              Text('QR Code Data: $qrCodeData')
            else
              const Text('No QR code data found'),
          ],
        ),
      ),
    );
  



  }
}