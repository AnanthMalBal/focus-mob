import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:timeplot_flutter/screens/appbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timeplot_flutter/screens/colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
// import 'package:permission_handler/permission_handler.dart';



class Qrcodegenerator extends StatefulWidget {
  const Qrcodegenerator({super.key});

  @override
  State<Qrcodegenerator> createState() => _QrcodegeneratorState();
}

class _QrcodegeneratorState extends State<Qrcodegenerator> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productIdController = TextEditingController();
  String qrData = '';

  @override
  void dispose() {
    productNameController.dispose();
    productIdController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: CommonAppBar(
      //   menuItems: [],
      //   title: 'QRCodeGenerator',
      //   showProfile: true,
      //   // onProfileTap: () {
      //   //   print('Profile tapped!');

      //   // },
      // ),
 body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: TextField(
            controller: productNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Product Name',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: TextField(
            controller: productIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Product ID',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.all(10),
              ),
              onPressed: () {
                setState(() {
                  qrData = '{"productName": "${productNameController.text}", "productId": "${productIdController.text}"}';
                });
              },
              child: const Text(
                'GENERATE QR CODE',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                 await saveQrAsPdf(qrData); // Save QR code as PDF
                
              },
              child: const Text('SAVE AS PDF'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (qrData.isNotEmpty)
          Center(
            child: QrImageView(
              data: qrData,
              size: 280,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: const Size(100, 100),
              ),
            ),
          ),
      ],
    )
    );

  }
  //  Future<void> saveQrAsPdf(String text) async {
  //   final pdf = pw.Document();

  //   final qrImage = await QrPainter(
  //     data: text,
  //     version: QrVersions.auto,
  //     gapless: false,
  //   ).toImage(280); // Convert the QR code to an image

  //   final qrImageData = await qrImage.toByteData(format: ImageByteFormat.png);
  //   final imageBytes = qrImageData!.buffer.asUint8List();

  //   final pdfImage = pw.MemoryImage(imageBytes);

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           child: pw.Image(pdfImage, width: 280, height: 280),
  //         ); // Add the QR image to the PDF
  //       },
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   final file = File('${output.path}/qr_code.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('QR code saved as PDF at ${file.path}')),
  //   );
  // }
//   Future<void> saveQrAsPdf(String text) async {
//   final pdf = pw.Document();

//   final qrImage = await QrPainter(
//     data: text,
//     version: QrVersions.auto,
//     gapless: false,
//   ).toImage(280);

//   final qrImageData = await qrImage.toByteData(format: ImageByteFormat.png);
//   final imageBytes = qrImageData!.buffer.asUint8List();

//   final pdfImage = pw.MemoryImage(imageBytes);

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Image(pdfImage, width: 280, height: 280),
//         );
//       },
//     ),
//   );

//   // Define a specific path on your laptop
//   final outputDir = Directory(r'C:\Users\Siva\Desktop\Generated_QR_Codes');
//   if (!outputDir.existsSync()) {
//     outputDir.createSync(recursive: true);
//   }

//   // Save the file with a unique name
//   final file = File(path.join(outputDir.path, 'qr_code_${DateTime.now().millisecondsSinceEpoch}.pdf'));
//   await file.writeAsBytes(await pdf.save());

//   print('QR code saved as PDF at ${file.path}');
// }


// Future<void> saveQrAsPdf(String text) async {
//   // Create a PDF document as usual
//   final pdf = pw.Document();

//   // Create QR image
//   final qrImage = await QrPainter(
//     data: text,
//     version: QrVersions.auto,
//     gapless: false,
//   ).toImage(280);

//   final qrImageData = await qrImage.toByteData(format: ImageByteFormat.png);
//   final imageBytes = qrImageData!.buffer.asUint8List();

//   final pdfImage = pw.MemoryImage(imageBytes);

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Image(pdfImage, width: 280, height: 280),
//         );
//       },
//     ),
//   );

//   // Get application documents directory
//   final documentsDir = await getApplicationDocumentsDirectory();
//   final outputDir = Directory(path.join(documentsDir.path, 'Generated_QR_Codes'));
  
//   // Ensure the directory exists
//   if (!outputDir.existsSync()) {
//     outputDir.createSync(recursive: true);
//   }

//   // Save the file with a unique name
//   final file = File(path.join(outputDir.path, 'qr_code_${DateTime.now().millisecondsSinceEpoch}.pdf'));
//   await file.writeAsBytes(await pdf.save());

//   print('QR code saved as PDF at ${file.path}');
// }

Future<void> saveQrAsPdf(String text) async {
  // Create a PDF document
  final pdf = pw.Document();

  // Create QR image
  final qrImage = await QrPainter(
    data: text,
    version: QrVersions.auto,
    gapless: false,
  ).toImage(280);

  final qrImageData = await qrImage.toByteData(format: ImageByteFormat.png);
  final imageBytes = qrImageData!.buffer.asUint8List();

  final pdfImage = pw.MemoryImage(imageBytes);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(pdfImage, width: 280, height: 280),
        );
      },
    ),
  );

  // Get application documents directory
  final documentsDir = await getApplicationDocumentsDirectory();
  final outputDir = Directory(path.join(documentsDir.path, 'Generated_QR_Codes'));

  // Ensure the directory exists
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  // Save the file with a unique name
  final file = File(path.join(outputDir.path, 'qr_code_${DateTime.now().millisecondsSinceEpoch}.pdf'));
  await file.writeAsBytes(await pdf.save());

  print('QR code saved as PDF at ${file.path}');

  // Open the PDF file
  await OpenFile.open(file.path);
}


}


