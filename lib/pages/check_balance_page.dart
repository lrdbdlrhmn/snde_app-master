//import 'dart:convert';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:snde/constants.dart';
import 'package:snde/functions.dart';
import 'package:snde/services/api_service.dart';
//import 'package:snde/services/auth_service.dart';
import 'package:snde/widgets/input_decoration_widget.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

class CheckBalancePage extends StatefulWidget {
  const CheckBalancePage({Key? key}) : super(key: key);

  @override
  CheckBalancePageState createState() => CheckBalancePageState();
}

class CheckBalancePageState extends State<CheckBalancePage> {
  final _formKey = GlobalKey<FormState>();

  String _code = '';
  bool _gettingBalance = false;
  bool _showingPdf = false;
  bool _showingPdfLoading = false;
  bool _hasBalance = false;
  bool _hasPdf = false;
  String name = '';
  String balance = '';
  String? doc;
  //String doc = '';

  Future<void> _checkBalance() async {
    setState(() {
      _gettingBalance = true;
      _hasBalance = false;
      _hasPdf = false;
      _showingPdf = false;
      _showingPdfLoading = false;
      
    });

    try {
      final res = await apiService.get('check_balance/$_code');
      final result = res['result']['result'];
      
      if (result['status'] != 'ok') {
        
        throw 'no balance';
      }
      name = result['user']['nom'];
      balance = "${result['user']['solde']}";
      _hasBalance = true;
      _gettingBalance = false;
      _showPdf();
    } catch (error) {
      
       showToast(t(context, 'no_result'));
    }

    setState(() {
      _gettingBalance = false;
    });
  }

  Future<void> _showPdf() async {
    if (_gettingBalance || !_hasBalance) {
      return;
    }
    if (_hasPdf && doc != null) {
      Navigator.pushNamed(context, '/view_pdf', arguments: doc);
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
      
      //final res = await apiService.get('invoice/$_code');
      //final result = json.encode(res['result']);
    Map<String, String> headers = {
    //'api-key': 'XQd0e4n887CciZnk7h8Puo56sci26ay0cmy8DaRDesixelZvicRBgt2ZsPte',
    'Authorization': '',
    //'client-source': 'apis',
    //'app-v': appVersion,
    'app-language-x': ApiService.language
    };
      http.Response response = await http.get(Uri.parse('$baseUrl/${'invoice/$_code' ?? ''}'), headers: headers);

      final result = response.body;
      final codeResponse = response.statusCode;
      if (codeResponse == 200) {
        String targetPath = (await getApplicationDocumentsDirectory()).path;
        //showToast(t(context, '$targetPath/${targetPath ?? ''}'));
        var targetFileName = '$_code';
        var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        result, targetPath, targetFileName);
        doc = generatedPdfFile.path;

        
        
        if (_showingPdfLoading) {

          Navigator.pushNamed(context, '/view_pdf', arguments: doc);

          }
          _hasPdf = true;
      }

    } catch (error) {
      //showToast(t(context, '$error/${error ?? ''}'));
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
                        FaIcon(FontAwesomeIcons.check, color: Colors.green, size: 40),
                        SizedBox(height: 15),
                        Text('$name', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('${t(context, 'account_balance')}: $balance', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
                                  backgroundColor: MaterialStateProperty.all(Colors.black54),
                                  ),
                              onPressed: _gettingBalance || _showingPdfLoading ? null : _showPdf,
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
