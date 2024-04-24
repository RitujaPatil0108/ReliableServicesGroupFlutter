// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../../constants/colors_constants.dart';

Future<void> generateInvoicePDF(
    BuildContext context, Map<String, dynamic> invoiceData) async {
  final pdf = pw.Document();

  try {
    // Load Lato Regular font
    final latoRegularFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Lato-Regular.ttf'));

    // Load company logo image
    final Uint8List companyLogo =
        await loadImage('assets/images/company_logo.jpg');
    final pw.MemoryImage logoImage = pw.MemoryImage(companyLogo);

    // Header section
    final headerContent = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(logoImage, width: 100), // Adjust width of the logo
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Reliable Customer Service',
                style: pw.TextStyle(
                    font: latoRegularFont,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'khasra no 2274, shiv vihar, \nbehind shiv mandir, Rajeev nagar, \nGurgaon, Haryana, 122001\nMobile: +91 9899817109, 706502268',
                style: pw.TextStyle(font: latoRegularFont),
                textAlign: pw.TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );

    final hr = pw.Container(
        height: 1,
        color: PdfColors.grey800,
        margin: const pw.EdgeInsets.symmetric(vertical: 10));

    // Body section
    // Body section
    final bodyContent = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Invoice',
          style: pw.TextStyle(
              font: latoRegularFont,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        hr,
        // Display invoice data
        pw.Container(
          decoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey100, // Blue color box
          ),
          padding: const pw.EdgeInsets.all(10), // Padding for the box
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Date: ${invoiceData['date']}',
                        style: pw.TextStyle(font: latoRegularFont)),
                    pw.Text('Employee Name: ${invoiceData['employee_name']}',
                        style: pw.TextStyle(font: latoRegularFont)),
                    pw.Text('Call Number: ${invoiceData['call_number']}',
                        style: pw.TextStyle(font: latoRegularFont)),
                    pw.Text('Customer Name: ${invoiceData['customer_name']}',
                        style: pw.TextStyle(font: latoRegularFont)),
                    pw.Text('Brand Name: ${invoiceData['brand']}',
                        style: pw.TextStyle(font: latoRegularFont)),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('TCR Number: ${invoiceData['tcr_number']}',
                        style: pw.TextStyle(
                            font: latoRegularFont, color: PdfColors.blue)),
                  ],
                ),
              ),
            ],
          ),
        ),
        hr,
        // Table header
        pw.Container(
          color: PdfColors.blueGrey100,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text('Serial No.',
                        style: pw.TextStyle(
                            font: latoRegularFont,
                            fontWeight: pw.FontWeight.bold))),
              ),
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text('Item',
                        style: pw.TextStyle(
                            font: latoRegularFont,
                            fontWeight: pw.FontWeight.bold))),
              ),
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text('Qty',
                        style: pw.TextStyle(
                            font: latoRegularFont,
                            fontWeight: pw.FontWeight.bold))),
              ),
            ],
          ),
        ),

        hr,
        // Items from finalCartList
        for (int i = 0; i < invoiceData['items'].length; i++)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text('${i + 1}',
                        style: pw.TextStyle(font: latoRegularFont))),
              ),
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text(invoiceData['items'][i]['item_name'],
                        style: pw.TextStyle(font: latoRegularFont))),
              ),
              pw.Expanded(
                child: pw.Container(
                    alignment:
                        pw.Alignment.center, // Aligning content in center
                    child: pw.Text(
                        invoiceData['items'][i]['quantity'].toString(),
                        style: pw.TextStyle(font: latoRegularFont))),
              ),
            ],
          ),

        hr,
        // Total amount
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(vertical: 10),
          height: 12,
          color: PdfColors.blueGrey100,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Total amount to be received (Rs.):',
                style: pw.TextStyle(font: latoRegularFont)),
            pw.Text('Rs.${invoiceData['total_price']}',
                style: pw.TextStyle(font: latoRegularFont)),
          ],
        ),
        hr,
        // Total amount in words
        pw.Text(
            'Total amount in words: Rs. ${amountInWords((invoiceData['total_price']))} only.',
            style: pw.TextStyle(font: latoRegularFont)),
        hr,
        // Bank details
        pw.Text('Note: Company Bank details',
            style: pw.TextStyle(font: latoRegularFont)),
        pw.Text('Account Name: Reliable Customer Service',
            style: pw.TextStyle(font: latoRegularFont)),
        pw.Text('IFSC code: HDFC0000616',
            style: pw.TextStyle(font: latoRegularFont)),
        pw.Text('Bank name: HDFC', style: pw.TextStyle(font: latoRegularFont)),
        pw.Text('Account number: 50200056823276',
            style: pw.TextStyle(font: latoRegularFont)),
      ],
    );

    // Footer
    final footer = pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 50, horizontal: 100),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'Authorised Service Center SAMSUNG, RelianceresQ',
            style: pw.TextStyle(font: latoRegularFont, color: PdfColors.grey),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Service charge, gas or part warranty is for 1 month only',
            style: pw.TextStyle(
                font: latoRegularFont, fontSize: 10, color: PdfColors.grey),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headerContent,
              bodyContent,
              footer,
            ],
          );
        },
      ),
    );

    // Save PDF file
    final output = await getApplicationDocumentsDirectory();
    final pdfFile = File('${output.path}/invoice.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Display PDF preview
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Image.asset(
                  'assets/images/company_logo.jpg',
                  height: 40,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: ColorsConstants.primaryBlue),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: ColorsConstants.primaryBlue),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: ColorsConstants.primaryBlue),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download_rounded),
                        SizedBox(width: 8),
                        Text('Download'),
                      ],
                    ),
                  ),
                ],
                onSelected: (String value) async {
                  if (value == 'download') {
                    // Save PDF file
                    final Uint8List pdfBytes = await pdf.save();
                    final directory =
                        await PathProviderPlatform.instance.getDownloadsPath();
                    final filePath = '$directory/invoice.pdf';
                    final File file = File(filePath);
                    await file.writeAsBytes(pdfBytes);
                    // Print the file path
                    print('PDF saved at: $filePath');
                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('PDF downloaded successfully'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
              ),
            ],
          ),
          body: PDFView(filePath: pdfFile.path),
        ),
      ),
    );
  } catch (e) {
    print('Error generating PDF: $e');
    // Handle error
  }
}

// Function to load image as Uint8List
Future<Uint8List> loadImage(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}

String amountInWords(int amount) {
  final List<String> units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'
  ];
  final List<String> teens = [
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ];
  final List<String> tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  if (amount == 0) return 'Zero';

  // Function to convert three-digit number to words
  String convertThreeDigit(int num) {
    String word = '';
    if (num >= 100) {
      word += '${units[num ~/ 100]} Hundred ';
      num %= 100;
    }
    if (num >= 20) {
      word += '${tens[num ~/ 10]} ';
      num %= 10;
    } else if (num >= 10) {
      word += '${teens[num - 10]} ';
      num = 0;
    }
    if (num > 0) {
      word += '${units[num]} ';
    }
    return word.trim(); // Trim any extra spaces
  }

  // Function to convert the given number to words
  String convertToWords(int num) {
    String words = '';
    if (num >= 10000000) {
      words += '${convertThreeDigit(num ~/ 10000000)} Crore ';
      num %= 10000000;
    }
    if (num >= 100000) {
      words += '${convertThreeDigit(num ~/ 100000)} Lakh ';
      num %= 100000;
    }
    if (num >= 1000) {
      words += '${convertThreeDigit(num ~/ 1000)} Thousand ';
      num %= 1000;
    }
    if (num > 0) {
      words += '${convertThreeDigit(num)}';
    }
    return words.trim();
  }

  // Convert the given amount to words
  return convertToWords(amount);
}
