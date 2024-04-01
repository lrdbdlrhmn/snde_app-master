import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snde/services/api_service.dart';

bool isNN(dynamic value) {
  return !['0', 0, '', null, 'null'].contains(value);
}

showToast(message, {Color color = Colors.red}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: color,
    textColor: Colors.white,
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
  );
}

showAlertDialog(
    BuildContext context, String title, String body, void Function() callback) {
  Widget okButton = TextButton(
    child: Text(t(context, 'ok')),
    onPressed: () {
      Navigator.pop(context);
      callback();
    },
  );
  Widget cancelButton = TextButton(
    child: Text(t(context, 'cancel')),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      okButton,
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


Future<XFile?> compressAndGetFile(File file) async {
  Directory appDir = await getApplicationDocumentsDirectory(); 
  String filePath = file.absolute.path; 
  final outPath = "${appDir.absolute.path}/${filePath.split('/').last}";
  var result = await FlutterImageCompress.compressAndGetFile(
      filePath, outPath,
      quality: 88,
    );
  return result;
}

bool isPhone(int phone){
  return phone.toString().startsWith('2') || phone.toString().startsWith('3') || phone.toString().startsWith('4');
}

String t(BuildContext context, key){
  return FlutterI18n.translate(context, key);
}

String formatDate(String date){
  List<String> fDate = date.split('T');
  List<String> time = fDate.last.split(':');
  return "${fDate.first}";
}

Color reportStatusColor(String status){
  return status == 'new' ? Colors.black : (status == 'fake' ? Colors.red : (status == 'technical' ? Colors.orange : Colors.green));
}