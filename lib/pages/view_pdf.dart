//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class ViewPdf extends StatefulWidget {
  ViewPdf({Key? key}) : super(key: key);

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  Widget build(BuildContext context) {
    //final doc = ModalRoute.of(context)!.settings.arguments as PDFDocument;
    return Scaffold(
      //body: PDFViewer(document: doc, scrollDirection: Axis.vertical,),
    );
  }
}