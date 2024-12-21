import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:maru/packages/maru_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class InAppBrowser extends StatefulWidget {
  @override
  _InAppBrowserState createState() => _InAppBrowserState();
}

class _InAppBrowserState extends State<InAppBrowser> {
  String? filePath;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Moved the logic from initState to didChangeDependencies
    _downloadAndDisplayPdf();
  }


  Future<String> getSpecificDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final specificDir = Directory('${directory.path}/Maru');
    if (!await specificDir.exists()) {
      await specificDir.create(recursive: true);
    }
    return specificDir.path;
  }

  String getDateString() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(now);
  }

  Future<void> _downloadAndDisplay() async{
    String dateString = getDateString();
    final path = await getSpecificDirectoryPath();  // Get the specific directory
    final fileName = "${dateString}.pdf"; // Get the file name from the URL
    final filePath = '$path/$fileName';
    print(filePath);
  }

  // Function to download the PDF
  Future<void> _downloadAndDisplayPdf() async {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    try {
      // Send HTTP GET request to the server
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the directory to store the PDF file
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/report.pdf');

        // Save the downloaded PDF data to a local file
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          filePath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to download PDF. Status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Function to delete the temporary PDF file
  Future<void> _deletePdfFile() async {
    print("Delete ${filePath}");
    if (filePath != null) {
      final file = File(filePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    CustomThemes customs = new CustomThemes();
    return Scaffold(
      appBar: AppBar(
        title: Text('View Report'),
      ),
      body: isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitCircle(
                  color: customs.primaryColor,
                  size: 50.0,
                ),
                Text("Loading Report...", style: customs.primaryTextStyle(size: 10,))
              ],
            )
          : filePath == null
          ? Center(child: Text('Failed to load PDF'))
          : PDFView(
            filePath: filePath!,
            onPageChanged: (int? currentPage, int? totalPages) {
              // You can track page changes here if needed
              print("Current page: $currentPage");
            },
            onPageError:(page, error) => {
              print("page: ${page}")
            },
            onViewCreated: (_) {
              print("PDF created!");
              // Once PDF is loaded, you can delete the file
            },
      ),
    );
  }

  @override
  void dispose() {
    // Ensure the file is deleted if the user leaves the screen
    _deletePdfFile();
    super.dispose();
  }
}
