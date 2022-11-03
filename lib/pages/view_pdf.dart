//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
class ViewPdf extends StatefulWidget {
  ViewPdf({Key? key}) : super(key: key);

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: PDFView(
          filePath: doc,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (_pages) {
            setState(() {
              //pages = _pages;
              //isReady = true;
            });
          },
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            //_controller.complete(pdfViewController);
          },
        ),
    );
  }
}