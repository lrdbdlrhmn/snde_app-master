import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/pages/view_pdf.dart';
import 'package:http/http.dart' as http;
import 'package:snde/services/api_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

class CheckBalancePage extends StatefulWidget {
  const CheckBalancePage({Key? key}) : super(key: key);

  @override
  CheckBalancePageState createState() => CheckBalancePageState();
}

class CheckBalancePageState extends State<CheckBalancePage> {
  final _formKey = GlobalKey<FormState>();

  String _code = '';
  String _html = '';
  String doc = '';
  bool _gettingBalance = false;
  bool _showingPdf = false;
  bool _showingPdfLoading = false;
  bool _hasBalance = false;
  bool _hasPdf = false;
  String name = '';
  String balance = '';

  Future<void> _checkBalance() async {
    setState(() {
      _gettingBalance = true;
      _hasBalance = false;
      _hasPdf = false;
      _showingPdf = false;
      _showingPdfLoading = false;
    });

    try {
      final result = await apiService.get('check_balance/$_code');

      final res = result['result']['result'];

      if (res['status'] == 'ok') {
        name = res['user']['nom'];

        balance = "${res['user']['solde']}";
      }

      _hasBalance = true;
      _gettingBalance = false;
    } catch (error) {
      showToast(t(context, 'no_result'));
    }

    setState(() {
      _gettingBalance = false;
    });
  }

  Future<String> fetchHTML() async {
    final response = await http.get(Uri.parse('$baseUrl/invoice/$_code'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load HTML');
    }
  }

  Future<void> _showPdf() async {
    if (_gettingBalance || !_hasBalance) {
      return;
    }
    if (_hasPdf && doc != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewPdf(
              pdfPath: doc,
              pageTitle: name,
            ),
          ));
      return;
    }
    if (_showingPdf) {
      setState(() {
        _showingPdfLoading = true;
      });
      return;
    }
    setState(() {
      _showingPdf = true;
    });

    try {
      _html = await fetchHTML();
      if (_html.isNotEmpty) {
        Directory? appDocDir = await getDownloadsDirectory();
        final targetPath = appDocDir?.path;
        final targetFileName = _code;

        final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
            _html, targetPath!, targetFileName);
        doc = generatedPdfFile.path;

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewPdf(
                pdfPath: doc,
                pageTitle: name,
              ),
            ));
      } else {
        showToast(t(context, 'no_result'));
      }

      if (_showingPdfLoading) {}
      _hasPdf = true;
    } catch (error) {
      showToast(t(context, 'no_result'));
    }

    setState(() {
      _showingPdfLoading = false;
      _showingPdf = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            title: Text(t(context, 'account_balance')), centerTitle: true),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                if (_hasBalance)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.check,
                            color: Colors.green, size: 40),
                        SizedBox(height: 15),
                        Text('$name',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('${t(context, 'account_balance')}: $balance',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            // width: 12/0,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black54),
                              ),
                              onPressed: _gettingBalance || _showingPdfLoading
                                  ? null
                                  : _showPdf,
                              //,
                              child: _showingPdfLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(t(context, 'show_pdf')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: inputDecorationWidget(
                            text: t(context, 'reference'),
                            icon: FontAwesomeIcons.creditCard),
                        onChanged: (value) => setState(() {
                          _code = value;
                        }),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t(context, 'enter_reference');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: 150,
                          height: 55,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0)),
                            onPressed: _gettingBalance ? null : _checkBalance,
                            child: _gettingBalance
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(t(context, 'check_balance')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
