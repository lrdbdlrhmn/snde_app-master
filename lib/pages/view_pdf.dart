
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class ViewPdf extends StatefulWidget {
  final String pdfPath;
  final String pageTitle;

  ViewPdf({Key? key, required this.pdfPath, required this.pageTitle})
      : super(key: key);

  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pdfPath);
    print(widget.pageTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.pageTitle),centerTitle : true,
      ),
      body: widget.pdfPath.isEmpty ? const CircularProgressIndicator() : PDFView(
        filePath: widget.pdfPath,
        onError: (error) {
          print(error);
        },
      ),
    );
  }
}
